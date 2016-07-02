require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

require 'github_release_notes/rake_task'
task default: :spec

desc 'Re-generate a Release Notes for a project'
task :testrun do
  sh 'bundle exec rake --libdir lib --rakefile spec/test.rake'
end