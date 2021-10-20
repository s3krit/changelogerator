require "json"
require_relative "../lib/changelogerator"
require "test/unit"

class TestChangelogerator < Test::Unit::TestCase
  def test_meta_1_commit
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

    ref1 = "2ebabcec7fcbb3d13a965a852df0559a4aa12a5e"
    ref2 = "9c05f9753b2f939ccf5ba18c08dd4c83c3ab9e0b"
    cl = Changelog.new(
      "paritytech/polkadot", ref1, ref2,
      token: ENV["GITHUB_TOKEN"],
      prefix: true,
    )

    j = cl.to_json
    assert_equal(1, cl.changes.length)
    assert_equal(["A", "B", "C"], cl.changes[0].meta.keys) # A2 + B0 + C1

    # assert_equal(1, cl.meta.A?.count)

    p cl.meta

    puts "JSON Length: %d" % [j.length]
    assert(j.length > 4_600)
    assert(j.length < 5_000)

    # puts j
  end
end
