require "json"
require_relative "../lib/changelogerator"
require "test/unit"

class TestChangelogerator < Test::Unit::TestCase
  def test_polkadot_labels
    ref1 = "2ebabcec7fcbb3d13a965a852df0559a4aa12a5e"
    ref2 = "9c05f9753b2f939ccf5ba18c08dd4c83c3ab9e0b"

    cl = Changelog.new(
      "paritytech/polkadot", ref1, ref2,
      token: ENV["GITHUB_TOKEN"],
      prefix: true,
    )

    j = cl.to_json
    assert_equal(1, cl.changes.length)

    puts "JSON Length: %d" % [j.length]
    assert(j.length > 12_000)
    assert(j.length < 13_000)
  end
end
