require "json"
require_relative "../lib/changelogerator"
require "test/unit"

class TestChangelogerator < Test::Unit::TestCase
  def test_polkadot_labels
    ref1 = "2ebabcec7fcbb3d13a965a852df0559a4aa12a5e"
    ref2 = "9c05f9753b2f939ccf5ba18c08dd4c83c3ab9e0b"

    # We define the labels we are interested in for a given
    # project
    labels_polkadot = [
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
      {
        priority: 7,
        label: "C7-high ❗️",
        text: "Upgrade priority:❗ **HIGH** ❗ Please upgrade your node as soon as possible",
      },
      {
        priority: 9,
        label: "C9-critical ‼️",
        text: "Upgrade priority: ❗❗ **URGENT** ❗❗ PLEASE UPGRADE IMMEDIATELY",
      },
    ]

    cl = Changelog.new(
      "paritytech/polkadot", ref1, ref2,
      token: ENV["GITHUB_TOKEN"], labels: labels_polkadot,
      prefix: true,
    )

    j = cl.to_json
    assert_equal(1, cl.changes.length)
    puts "JSON Length: %d" % [j.length]
    assert(j.length > 4_000)
    assert(j.length < 4_400)
  end
end
