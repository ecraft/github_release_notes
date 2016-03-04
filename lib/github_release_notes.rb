require 'github_release_notes/version'

require 'erb'
require 'json'
require 'ansi/code'
require 'octokit'
require 'kramdown'
require 'active_support/core_ext/hash/slice'
require 'active_support/core_ext/object/blank'
require 'rake/clean'

module GithubReleaseNotes
  Error = Class.new(StandardError)
end
require 'github_release_notes/configuration'
require 'github_release_notes/fetcher'
require 'github_release_notes/formatter'
