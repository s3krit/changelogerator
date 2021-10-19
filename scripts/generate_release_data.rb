require_relative "../lib/changelogerator"
require "test/unit"

owner = ARGV[0]
repo = ARGV[1]
ref1 = ARGV[2]
ref2 = ARGV[3]

if repo.nil? || ref1.nil? || ref2.nil?
  STDERR.puts "Missing args"
  exit 1
end

fullrepo = "%s/%s" % [owner, repo]
labels_polkadot = [
  {
    priority: 1,
    label: "C1-low 📌",
    text: "Upgrade priority: **Low** (upgrade at your convenience)",
    key: "P1",
  },
  {
    priority: 3,
    label: "C3-medium 📣",
    text: "Upgrade priority: **Medium** (timely upgrade recommended)",
    key: "P3",
  },
  {
    priority: 7,
    label: "C7-high ❗️",
    text: "Upgrade priority:❗ **HIGH** ❗ Please upgrade your node as soon as possible",
    key: "P7",
  },
  {
    priority: 9,
    label: "C9-critical ‼️",
    text: "Upgrade priority: ❗❗ **URGENT** ❗❗ PLEASE UPGRADE IMMEDIATELY",
    key: "P9",
  },
]

cl = Changelog.new(
  fullrepo, ref1, ref2,
  token: ENV["GITHUB_TOKEN"], labels: labels_polkadot,
  prefix: true,
)

puts cl.to_json
