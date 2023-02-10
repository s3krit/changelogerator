# frozen_string_literal: true

require 'json'
require_relative '../lib/changelogerator'
require_relative './utils'
require 'test/unit'

class TestChangelogerator < Test::Unit::TestCase
  def test_meta_1_commit
    change = Change.new(%w[A1-foo A2-foo B0-foo B1-foo B2-foo])
    compute_change_meta(change)

    assert_equal(%w[A B], change.meta.keys)

    assert_equal(change.meta['A']['agg']['min'], 1) # A(1)
    assert_equal(change.meta['A']['agg']['max'], 2) # A(2)
    assert_equal(change.meta['A']['agg']['count'], 2) # A1 + A2

    assert_equal(change.meta['B']['agg']['min'], 0) # B(0)
    assert_equal(change.meta['B']['agg']['max'], 2) # B(2)
    assert_equal(change.meta['B']['agg']['count'], 3) # B0 + B1 + B2

    assert_equal(JSON.pretty_generate(change.meta), '{
  "A": {
    "agg": {
      "count": 2,
      "max": 2,
      "min": 1
    },
    "A1": {
      "value": 1,
      "text": "foo"
    },
    "A2": {
      "value": 2,
      "text": "foo"
    }
  },
  "B": {
    "agg": {
      "count": 3,
      "max": 2,
      "min": 0
    },
    "B0": {
      "value": 0,
      "text": "foo"
    },
    "B1": {
      "value": 1,
      "text": "foo"
    },
    "B2": {
      "value": 2,
      "text": "foo"
    }
  }
}')
  end
end
