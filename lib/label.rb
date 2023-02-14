# frozen_string_literal: true

### Label = Code + Number + description
class Label
  attr_accessor :code, :number, :description

  # Return the label code for a change if the label name matches the expected pattern.
  # nil otherwise.
  def parse(label)
    m = match = label.match(/^([a-z])(\d+)\s*-?\s*(.*)$/i)
    return nil unless m

    letter, digits, text = match.captures
    number = digits.to_i
    [letter, number, text]
  end

  def initialize(input)
    p = parse(input)

    @code = p[0].upcase
    @number = p[1]
    @description = p[2] unless p[2].empty?
  end
end
