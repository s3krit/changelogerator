# frozen_string_literal: true

### Label = Letter + Number [+ Description]
class Label
  attr_accessor :letter, :number, :description

  # Return the label letter for a change if the label name matches the expected pattern.
  # nil otherwise.
  def parse(label)
    m = match = label.match(/^([a-z])(\d+)\s*-?\s*(.*)$/i)
    return nil unless m

    letter, digits, text = match.captures
    number = digits.to_i
    [letter, number, text]
  end

  def initialize(input)
    raise InvalidInput, 'Invalid, it must be a non-empty string' unless input

    p = parse(input)
    raise InvalidLabel, format('Invalid label "%<input>s"', { input: input }) unless p

    @letter = p[0].upcase
    @number = p[1]
    @description = p[2] unless p[2].empty?
  end

  ### Implemented for compatibility reasons
  def name
    puts format('%<l>s%<n>d', { l: @letter, n: @number })
  end

  def to_str
    format('%<l>s%<n>d - %<d>s', { l: @letter, n: @number, d: @description })
  end
end

class InvalidLabel < StandardError; end

class InvalidInput < StandardError; end
