# frozen_string_literal: true

# A small wrapper class for more easily generating and manipulating Github/Git
# changelogs. Given two different git objects (sha, tag, whatever), it will
# find all PRs that made up that diff and store them as a list. Also allows
# for filtering by label, and the importance of that change (priorities), based
# on how we classify the importance of PRs in the paritytech/polkadot project.
# Probably not tremendously useful to other projects.
class Changelog
  require 'octokit'
  require 'git_diff_parser'

  attr_accessor :changes
  attr_reader :priority

  @priorities = [
    {
      priority: 1,
      label: 'C1-low',
      text: 'Upgrade priority: **Low** (upgrade at your convenience)'
    },
    {
      priority: 3,
      label: 'C3-medium',
      text: 'Upgrade priority: **Medium** (timely upgrade recommended)'
    },
    {
      priority: 7,
      label: 'C7-high',
      text: 'Upgrade priority:❗ **HIGH** ❗ Please upgrade your node as soon as possible'
    },
    {
      priority: 9,
      label: 'C9-critical',
      text: 'Upgrade priority: ❗❗ **URGENT** ❗❗ PLEASE UPGRADE IMMEDIATELY'
    }
  ]

  class << self
    attr_reader :priorities
  end

  # Return highest priority from an array of changes (NOT the actual Changelog
  # object)
  def self.highest_priority_for_changes(changes)
    @priorities.find do |p|
      p[:priority] == changes.map do |change|
        change[:priority][:priority]
      end.max
    end
  end

  def self.changes_with_label(changes, label)
    changes.select do |change|
      change[:labels].any? { |c| c[:name] == label } == true
    end
  end

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
    @priorities = self.class.priorities
    @gh = Octokit::Client.new(
      access_token: token
    )
    @prefix = prefix
    @changes = prs_from_ids(pr_ids_from_git_diff(from, to)).map(&:to_hash)
    # add priority to each change
    @changes.map { |c| apply_priority_to_change(c) }
  end

  def changes_with_label(label)
    self.class.changes_with_label(@changes, label)
  end

  def runtime_changes?
    nil
  end

  def add(change)
    changes.prepend(apply_priority_to_change(change))
  end

  def add_from_id(id)
    pull = @gh.pull_request(@repo, id)
    add(prettify_title(pull))
  end

  private

  def apply_priority_to_change(change)
    @priorities.each do |p|
      change[:priority] = p if change[:labels].any? { |l| l[:name] == p[:label] }
    end
    change
  end

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
