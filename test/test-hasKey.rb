require 'json'
require_relative "../lib/changelogerator"
require "test/unit"

class TestChangelogerator < Test::Unit::TestCase
  def test_hasKey_1_commit
    labels = [
      {
        priority: 1,
        label: "C1-low 📌",
        text: "Upgrade priority: **Low** (upgrade at your convenience)",
      },
      {
        priority: 3,
        label: "C3-medium 📣",
        text: "Upgrade priority: **Medium** (timely upgrade recommended)",
      },
    ]

    interesting_labels [ "B1", "C5", "D9" ];

    ref1 = "2ebabcec7fcbb3d13a965a852df0559a4aa12a5e"
    ref2 = "9c05f9753b2f939ccf5ba18c08dd4c83c3ab9e0b"
    cl = Changelog.new(
      "paritytech/polkadot", ref1, ref2, labels: labels,
      token: ENV["GITHUB_TOKEN"],
      prefix: true,
    )

    j = cl.to_json
    assert_equal(1, cl.changes.length)
    hasKey = cl.changes[0].hasKey
    puts "hasKey:"
    puts hasKey
    # assert_equal(1, hasKey.length)
    puts "JSON Length: %d" % [j.length]
    assert(j.length > 4_000)
    assert(j.length < 4_500)

    # puts j
  end
end
