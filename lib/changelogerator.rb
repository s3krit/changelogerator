# frozen_string_literal: true

require "pry"

# A small wrapper class for more easily generating and manipulating Github/Git
# changelogs. Given two different git objects (sha, tag, whatever), it will
# find all PRs that made up that diff and store them as a list. Also allows
# for filtering by label, and the importance of that change (labels), based
# on how we classify the importance of PRs in the paritytech/polkadot project.
class Changelog
  require "octokit"
  require "git_diff_parser"
  require "json"

  attr_accessor :repository
  attr_accessor :changes
  attr_accessor :meta
  attr_reader :label

  def self.changes_with_label(changes, label)
    changes.select do |change|
      change[:labels].any? { |c| c[:name] == label } == true
    end
  end

  # Go through all changes and compute some
  # aggregated values
  def compute_global_meta()
    @meta = {}

    @changes.each do |change|
      # here we remove some of the fields to reduce (considerably) the size
      # of the json output
      change.head = nil
      change.base = nil
      change._links = nil

      change[:meta].keys.each do |meta_key|
        current = change[:meta][meta_key]

        meta[meta_key] = {} unless meta[meta_key]
        meta[meta_key][:min] = current[:value] if !meta[meta_key][:min] || current[:value] < meta[meta_key][:min]
        meta[meta_key][:max] = current[:value] if !meta[meta_key][:max] || current[:value] > meta[meta_key][:max]
        meta[meta_key][:count] = 0 if !meta[meta_key][:count]
        meta[meta_key][:count] += 1
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

  # Return the label code for a change
  # if the label name matches the expected pattern.
  # nil otherwise.
  def self.get_label_code(name)
    if match = name.match(/^([a-z])(\d+)-(.*)$/i)
      letter, number, text = match.captures
      return [letter, number, text]
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
  def initialize(github_repo, from, to, token: "", prefix: nil)
    @repo = github_repo
    @gh = Octokit::Client.new(
      access_token: token,
    )
    @repository = @gh.repository(@repo)
    @prefix = prefix
    @changes = prs_from_ids(pr_ids_from_git_diff(from, to))
    @changes.map do |c|
      compute_change_meta(c)
    end

    compute_global_meta()
  end

  def add(change)
    compute_change_meta(change)
    prettify_title(change)
    changes.prepend(change)
    @meta = compute_global_meta()
  end

  # Add a pull request from id
  def add_from_id(id)
    pull = @gh.pull_request(@repo, id)
    add pull
  end

  def to_json
    opts = {
      array_nl: "\n",
      object_nl: "\n",
      indent: "  ",
      space_before: " ",
      space: " ",
    }
    obj = @changes

    commits = {
        meta: @meta,
        repository: @repository.to_h,
        changes: obj.map(&:to_h),
    }

    JSON.fast_generate(commits, opts)
  end

  private

  # Compute and attach metadata about one change
  def compute_change_meta(change)
    meta = Hash.new

    change.labels.each do |label|
      letter, number, text = self.class.get_label_code(label.name)
      if letter && number
        meta[letter] = {
          value: number.to_i,
          text: text,
        }
      end
    end

    change["meta"] = meta
  end
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
    @gh.compare(@repo, from, to).commits.map do |c|
      title = c.commit.message.split("\n\n").first
      next unless title =~ /\(#[0-9]+\)$/

      title.gsub(/.*#([0-9]+)\)$/, '\1')
    end.compact.map(&:to_i)
  end

  def prs_from_ids(ids)
    batch_size = 100
    prs = []
    @gh.pulls(@repo, state: "closed", per_page: batch_size)
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
