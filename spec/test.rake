require 'github_release_notes/rake_task'
require 'rake/clean'

directory 'tmp/output'
CLEAN.include('tmp/output')

GithubReleaseNotes::RakeTask.new(:ghn_test) do |c|
  c.repo_slug = 'jesjos/active_record_upsert'
  c.html_output = 'tmp/output/active_record_upsert.html'
  c.markdown_output = 'tmp/output/active_record_upsert.md'
  c.verbose = true
end
task default: ['tmp/output', :ghn_test]
