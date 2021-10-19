# frozen_string_literal: true
require 'pry'

# A small wrapper class for more easily generating and manipulating Github/Git
# changelogs. Given two different git objects (sha, tag, whatever), it will
# find all PRs that made up that diff and store them as a list. Also allows
# for filtering by label, and the importance of that change (labels), based
# on how we classify the importance of PRs in the paritytech/polkadot project.
class Changelog
  require "octokit"
  require "git_diff_parser"
  require "json"

  attr_accessor :changes, :hasKey
  attr_reader :label

  @labels = []

  class << self
    attr_reader :labels
  end

  # Return highest priority from an array of changes
  # WARNING: This is NOT the actual Changelog object
  def self.highest_priority_for_changes(changes)
    @labels.find do |p|
      p[:label] == changes.map do |change|
        change[:label][:label]
      end.max
    end || @labels[0]
  end

  def self.changes_with_label(changes, label)
    changes.select do |change|
      change[:labels].any? { |c| c[:name] == label } == true
    end
  end

  def self.add_label(label)
    @labels.append(label)
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
  def initialize(github_repo, from, to, token: "", labels: [], prefix: nil)
    @repo = github_repo
    @labels = labels
    @gh = Octokit::Client.new(
      access_token: token,
    )
    @prefix = prefix
    @changes = prs_from_ids(pr_ids_from_git_diff(from, to))

    # add priority to each change
    @changes.map { |c| apply_priority_to_change(c) }
  end

  def add(change)
    changes.prepend(prettify_title(apply_priority_to_change(change)))
  end

  # Add a pull request from id
  def add_from_id(id)
    pull = @gh.pull_request(@repo, id)
    add pull
  end

  def to_json
    # return @changes.map(&:to_h).to_json
    opts = {
      array_nl: "\n",
      object_nl: "\n",
      indent: "  ",
      space_before: " ",
      space: " ",
    }
    obj = @changes
    obj.map do |commit|
      # here we remove some of the fields to reduce the size
      # of the json output
      commit.head = nil
      commit.base = nil
      commit._links = nil

    end
    commits = { commits: obj.map(&:to_h) }
    # JSON.fast_generate(commits.map(&:to_h), opts)
    JSON.fast_generate(commits, opts)
  end

  private

  def apply_priority_to_change(change)
    obj = {}
    @labels.each do |p|
      has = false
      has = true if change[:labels].any? { |l|
        l[:name] == p[:label]
      }

      change[:label] = p if has
      k = p[:label]
      # binding.pry

      obj[k] = has

      change[:hasKey]= obj
    end
    # Failsafe: add lowest priority if none detected
    # change[:label] ||= @labels[0]

    change
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
