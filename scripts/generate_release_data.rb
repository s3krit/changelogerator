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

cl = Changelog.new(
  fullrepo, ref1, ref2,
  token: ENV["GITHUB_TOKEN"],
  prefix: true,
)

puts cl.to_json
