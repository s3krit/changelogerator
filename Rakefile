# frozen_string_literal: true

require 'rake/testtask'
require 'rubygems'
require 'rubocop/rake_task'

spec = Gem::Specification.load('changelogerator.gemspec')
gem_name = format('changelogerator-%s.gem', spec.version)

# Remove generated gem files
task :clean do
  sh 'echo Deleting *.gem', verbose: false
  sh 'rm -f *.gem'
end

# Run the linter: rubocop
RuboCop::RakeTask.new(:lint) do |t|
  t.options = ['--display-cop-names']
end

# Run the tests
Rake::TestTask.new do |task|
  task.pattern = 'test/test_*.rb'
end

# Build the gem
task :build do
  sh 'gem build changelogerator.gemspec'
end

# Install the gem
task install: :build do
  sh format('gem install %s', gem_name)
end

# Publish the gem
task publish: [:build] do
  sh format('gem push ./%s', gem_name)
end

# Run all the checks
task check: %i[lint test build install]
