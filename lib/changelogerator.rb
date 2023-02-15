# frozen_string_literal: true

require_relative '../lib/label'
require_relative '../lib/change'

# A small wrapper class for more easily generating and manipulating Github/Git
# changelogs. Given two different git objects (sha, tag, whatever), it will
# find all PRs that made up that diff and store them as a list. Also allows
# for filtering by label, and the importance of that change (labels), based
# on how we classify the importance of PRs in the paritytech/polkadot project.
class Changelog
  require 'octokit'
  require 'git_diff_parser'
  require 'json'

  attr_accessor :repository, :changes, :meta
  attr_reader :label

  def self.changes_with_label(changes, label)
    changes.select do |change|
      change[:labels].any? { |c| c[:name] == label } == true
    end
  end

  # Go through all changes and compute some
  # aggregated values
  def compute_global_meta
    @meta = {}

    @changes.each do |change|
      # here we remove some of the fields to reduce (considerably) the size
      # of the json output
      change.head = nil
      change.base = nil
      change._links = nil

      change[:meta].each_key do |meta_key|
        aggregate = change[:meta][meta_key]['agg']

        if meta[meta_key]
          meta[meta_key][:min] = aggregate['min'] if aggregate['min'] < meta[meta_key][:min]
          meta[meta_key][:max] = aggregate['max'] if aggregate['max'] > meta[meta_key][:max]
          meta[meta_key][:count] += aggregate['count']
        else
          meta[meta_key] = {
            min: aggregate['min'],
            max: aggregate['max'],
            count: aggregate['count']
          }
        end
      end
    end
  end

  # Return the list of all the files in the changeset
  # that also in the given path
  def self.changes_files_in_paths?(change, paths)
    changed_files = GitDiffParser.parse(Octokit.get(change.diff_url)).files
    paths = [paths] unless paths.is_a? Array
    paths.each do |path|
      return true if changed_files.find { |l| l.match path }
    end
    nil
  end

  ## End of class methods

  # github_repo: 'paritytech/polkadot'
  # from: some git ref e.g., 7e30258, v1.2.3
  # to: some git ref e.g., 7e30258, v1.2.3
  #
  # Optional named parameters:
  # token: a Github personal access token
  # prefix: whether or not to prefix PR numbers with their repo in the changelog
  def initialize(github_repo, from, to, token: '', prefix: nil)
    @repo = github_repo
    @gh = Octokit::Client.new(
      access_token: token
    )
    @repository = @gh.repository(@repo)
    @prefix = prefix
    ids = pr_ids_from_git_diff(from, to)
    # The following takes very long time
    @changes = prs_from_ids(ids)
    @changes.map do |c|
      self.class.compute_change_meta(c)
    end

    compute_global_meta
  end

  def add(change)
    self.class.compute_change_meta(change)
    prettify_title(change)
    changes.prepend(change)
    @meta = compute_global_meta
  end

  # Add a pull request from id
  def add_from_id(id)
    pull = @gh.pull_request(@repo, id)
    add pull
  end

  def to_json(*_args)
    opts = {
      array_nl: "\n",
      object_nl: "\n",
      indent: '  ',
      space_before: ' ',
      space: ' '
    }
    obj = @changes

    commits = {
      meta: @meta,
      repository: @repository.to_h,
      changes: obj.map(&:to_h)
    }

    JSON.fast_generate(commits, opts)
  end

  # Compute and attach metadata about one change
  def self.compute_change_meta(change)
    meta = {}

    change.labels.each do |lbl|
      # letter, number, text = parse_change_label(label.name)
      label = Label.new(lbl.name)

      next unless label

      if meta.key?(label.letter)
        aggregate = meta[label.letter]['agg']
        aggregate['max'] = label.number if label.number > aggregate['max']
        aggregate['min'] = label.number if label.number < aggregate['min']
        aggregate['count'] += 1
      else
        meta[label.letter] = {
          'agg' => {
            'count' => 1,
            'max' => label.number,
            'min' => label.number
          }
        }
      end

      meta[label.letter]["#{label.letter}#{label.number}"] = {
        'value' => label.number,
        'text' => label.description
      }
    end

    change['meta'] = meta
  end

  private

  # Prepend the repo if @prefix is true
  def prettify_title(pull)
    pull[:pretty_title] = if @prefix
                            "#{pull[:title]} (#{@repo}##{pull[:number]})"
                          else
                            "#{pull[:title]} (##{pull[:number]})"
                          end
    pull
  end

  def pr_ids_from_git_diff(from, to)
    commits = @gh.compare(@repo, from, to).commits
    commits.map do |c|
      title = c.commit.message.split("\n\n").first
      regex = /.*#([0-9]+).*$/
      next unless title =~ regex

      title.gsub(regex, '\1')
    end.compact.map(&:to_i)
  end

  # TODO: See if we can make this quicker
  def prs_from_ids(ids)
    batch_size = 100
    prs = []
    @gh.pulls(@repo, state: 'closed', per_page: batch_size)
    cur_batch = @gh.last_response
    until ids.empty?
      prs += cur_batch.data.select { |pr| ids.include? pr.number }
      ids -= cur_batch.data.map(&:number)
      break if cur_batch.rels[:last].nil?

      cur_batch = cur_batch.rels[:next].get
    end
    prs.flatten
    prs.map { |pr| prettify_title(pr) }
  end
end
