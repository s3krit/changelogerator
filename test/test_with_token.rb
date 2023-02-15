# frozen_string_literal: true

require 'json'
require_relative '../lib/changelogerator'
require 'test/unit'
require 'pry'

class TestChangelogerator < Test::Unit::TestCase
  def setup
    gh_token = ENV['GITHUB_TOKEN']
    omit("Skipping because $GITHUB_TOKEN=#{gh_token}") if gh_token == 'disabled'
    raise 'Missing $GITHUB_TOKEN token' if gh_token.nil? || gh_token.empty?
  end

  def test_polkadot_1_commit
    ref1 = '2ebabcec7fcbb3d13a965a852df0559a4aa12a5e'
    ref2 = '9c05f9753b2f939ccf5ba18c08dd4c83c3ab9e0b'
    cl = Changelog.new(
      'paritytech/polkadot', ref1, ref2,
      token: ENV['GITHUB_TOKEN'],
      prefix: true
    )

    j = cl.to_json
    assert_equal(1, cl.changes.length)
    puts format('JSON Length: %d', j.length)
    assert(j.length > 11_000)
    assert(j.length < 13_000)
  end

  def test_polkadot_many_commits
    ref1 = 'v0.9.8'
    ref2 = 'v0.9.11'
    cl = Changelog.new(
      'paritytech/polkadot', ref1, ref2,
      token: ENV['GITHUB_TOKEN'],
      prefix: true
    )

    j = cl.to_json
    File.open('/tmp/polkadot.json', 'w') { |file| file.write(j) }
    assert_equal(244, cl.changes.length)
    puts format('JSON Length: %d', j.length)
    assert(j.length > 1_600_000)
    assert(j.length < 1_700_000)
  end

  def test_cumulus_many_commits
    ref1 = 'statemine-v1.0.0'
    ref2 = 'statemine_v4'
    cl = Changelog.new(
      'paritytech/cumulus', ref1, ref2,
      token: ENV['GITHUB_TOKEN'],
      prefix: true
    )

    j = cl.to_json
    File.open('/tmp/cumulus.json', 'w') { |file| file.write(j) }
    assert_equal(56, cl.changes.length)
    puts format('JSON Length: %d', j.length)
    assert(j.length > 200_000)
    assert(j.length < 220_000)
  end
end
