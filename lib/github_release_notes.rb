require 'github_release_notes/version'

require 'erb'
require 'ansi/code'
require 'octokit'
require 'kramdown'
require 'active_support/core_ext/hash/slice'
require 'active_support/core_ext/object/blank'
require 'rake/clean'

require 'github_release_notes/configuration'
require 'github_release_notes/fetcher'
require 'github_release_notes/formatter'

module GithubReleaseNotes
end
