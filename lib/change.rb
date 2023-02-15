# frozen_string_literal: true

require_relative '../lib/label'

### A class describe one change that can potentially have several labels
class Change
  attr_reader :labels

  def initialize(labels)
    # Below we test if we got the full data from Octokit or
    # only some fake data (label names only) from our tests.
    @labels = labels.map do |label|
      if label.respond_to?(:name)
        from_octokit(label)
      else
        from_str(label)
      end
    end

    @extra = {}
  end

  def []=(key, value)
    @extra[key] = value
  end

  def meta
    @extra['meta']
  end

  private

  def from_octokit(label)
    Label.new(label.name)
  end

  def from_str(label_name)
    Label.new(label_name)
  end
end
