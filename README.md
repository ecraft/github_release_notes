# GithubReleaseNotes

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/github_release_notes`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'github_release_notes'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install github_release_notes

## Usage

### Token

Add an environment variable `RELEASE_NOTES_GITHUB_TOKEN` with a GitHub token with repo access.

Read more at https://github.com/skywinder/github-changelog-generator#github-token

### Configuration

Name and configure a Rake task which suits you.

```
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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/github_release_notes.

