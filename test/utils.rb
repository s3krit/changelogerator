# frozen_string_literal: true

class Change
  attr_reader :labels

  class Label
    attr_reader :name

    def initialize(name)
      @name = name
    end
  end

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
