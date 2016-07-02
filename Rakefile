require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rake/clean'

RSpec::Core::RakeTask.new(:spec)

require 'github_release_notes/rake_task'
task default: :spec

directory 'tmp/output'
CLEAN.include 'tmp/output'

desc 'Re-generate a Release Notes for a project'
task testrun: ['tmp/output'] do
  sh 'bundle exec rake --libdir lib --rakefile spec/test.rake'
end
