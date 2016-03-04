# GithubReleaseNotes

Use the GitHub Releases feature to author end-user-friendly release notes, and keep the developer-facing gory details elsewhere.

This tool allows you to publish a long Markdown and HTML document with your releases.

## Installation

Add this line to your application's Gemfile, as an ecraft-private gem:

```ruby
gem 'github_release_notes'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install github_release_notes

## Usage

You set this up using a GitHub token and a custom Rake task.

### Token

Add an environment variable `RELEASE_NOTES_GITHUB_TOKEN` with a GitHub token with repo access.

Read more at https://github.com/skywinder/github-changelog-generator#github-token

### Configuration

Name and configure a Rake task which suits you.

```ruby
require 'github_release_notes/rake_task'

GithubReleaseNotes::RakeTask.new(:release_notes) do |config|
  config.repo_slug = 'olleolleolle/github_release_notes'
  config.skipped_release_prefixes = %w(broken012/ tst_)

  config.html_output = 'release_notes.html'
  config.markdown_output = 'release_notes.md'
  config.templates_path = 'templatefiles/release_notes_templates'
  config.token = ENV['RELEASE_NOTES_GITHUB_TOKEN']
  config.verbose = true
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ecraft/github_release_notes.

