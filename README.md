[![Build Status](https://travis-ci.com/ecraft/github_release_notes.svg?token=35kCpfKGskZKKBMy5SCM&branch=master)](https://travis-ci.com/ecraft/github_release_notes)

# GithubReleaseNotes

Use the GitHub Releases feature to author end-user-friendly release notes, and keep the developer-facing gory details elsewhere.

This tool allows you to publish a long Markdown and HTML document with your releases.

This does the exact opposite of what [github-changelog-generator](https://github.com/skywinder/github-changelog-generator) does.

## Installation

Add this line to your application's Gemfile, as an ecraft-private gem:

```ruby
group :development do
  gem 'github_release_notes', '>= 0.2.1', source: 'https://gem.fury.io/ecraft-gems/'
end
```

And then execute:

    $ bundle

## Usage

You set this up using **a GitHub token** and a **custom Rake task**.

### Token

Add an environment variable `RELEASE_NOTES_GITHUB_TOKEN` with a GitHub token with `repo` access.

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
  # This data will be made available to html_full.html.erb
  config.html_template_data = {
    title: 'Release Notes for GitHub Release Notes',
    copyright: 'Every year!',
    slogan: 'You break it, you buy it!'
  }
  # The script will look for these two:
  #
  # templatefiles/release_notes_templates/html_full.html.erb
  # templatefiles/release_notes_templates/release.md.erb
  config.templates_path = 'templatefiles/release_notes_templates'
  config.token = ENV['RELEASE_NOTES_GITHUB_TOKEN']
  # The regular log is colorful, but can be overridden
  # config.logger = Logger.new('some_output.log')
  # config.log_level = Logger::INFO
  config.filter_lambda = ->(rs) {
    rs.select {|r| r[:tag_name] =~ /v/ }
  }
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ecraft/github_release_notes.

