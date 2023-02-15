# frozen_string_literal: true

require 'rake'

Gem::Specification.new do |s|
  s.name = 'changelogerator'
  s.version = '0.10.0'
  s.summary = 'Changelog generation/management'
  s.authors = ['Martin Pugh', 'Wilfried Kopp']
  s.files = FileList['lib/**/*.rb', 'bin/changelogerator']
  s.test_files = s.files.grep(%r{^(test|spec|features)/})
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.description = 'A utility to fetch the data required to generate a changelog based on change in Github and formatted labels.'
  s.require_paths = ['lib']
  s.license = 'AGPL-3.0'
  s.homepage = 'https://github.com/s3krit/changelogerator'
  s.add_runtime_dependency 'git_diff_parser', '~> 3'
  s.add_runtime_dependency 'octokit', '~> 4'
  s.required_ruby_version = '>= 2.7'
  s.metadata = { 'rubygems_mfa_required' => 'true' }
end
