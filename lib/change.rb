# frozen_string_literal: true

require_relative '../lib/label'

### A class describe one change that can potentially have several labels
class Change
  attr_reader :labels

  def initialize(labels)
    @labels = labels.map do |label|
      Label.new(label)
    end
    @extra = {}
  end

  def []=(key, value)
    @extra[key] = value
  end

  def meta
    @extra['meta']
  end
end
