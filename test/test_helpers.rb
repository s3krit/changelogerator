# frozen_string_literal: true

require 'json'
require_relative '../lib/changelogerator'
require 'test/unit'

class TestChangelogerator < Test::Unit::TestCase
  def test_helpers
    letter, number, text = Changelog.get_label_code('B2-test')
    assert_equal('B', letter)
    assert_equal('2', number)
    assert_equal('test', text)

    letter, number, text = Changelog.get_label_code('Z44-test 😁')
    assert_equal('Z', letter)
    assert_equal('44', number)
    assert_equal('test 😁', text)

    letter, number, text = Changelog.get_label_code('123-foo')
    assert_equal(nil, letter)
    assert_equal(nil, number)
    assert_equal(nil, text)
  end
end
