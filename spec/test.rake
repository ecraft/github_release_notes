require 'github_release_notes/rake_task'

GithubReleaseNotes::RakeTask.new(:ghn_test) do |c|
  c.repo_slug = 'jesjos/active_record_upsert'
  c.html_output = './active_record_upsert.html'
  c.markdown_output = './active_record_upsert.md'
  c.verbose = true
end
task default: [:ghn_test]
