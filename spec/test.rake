require 'github_release_notes/rake_task'

GithubReleaseNotes::RakeTask.new(:ghn_test) do |c|
  c.repo_slug = 'hej'
  c.html_output = './hej.html'
end
task default: [:ghn_test]