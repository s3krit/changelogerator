# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'changelogerator'
  s.version = '0.0.13'
  s.date = '2020-10-01'
  s.summary = 'Changelog generation/management'
  s.description = 'Simple helper class for paritytech/polkadot changelogs'
  s.authors = ['Martin Pugh']
  s.files = ['lib/changelogerator.rb']
  s.license = 'AGPL-3.0'
  s.homepage = 'https://github.com/s3krit/changelogerator'
  s.add_runtime_dependency 'git_diff_parser', '~> 3'
  s.add_runtime_dependency 'octokit', '~> 4'
end
