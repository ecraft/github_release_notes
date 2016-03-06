module GithubReleaseNotes
  class Fetcher
    CACHE_FILE_NAME = '.github_releases.json'.freeze

    attr_reader :logger

    def initialize(config)
      @token = config.token
      @repo_slug = config.repo_slug
      @logger = config.logger
      validate_options!
    end

    # Returns release notes data, either from GitHub or a cached file.
    def fetch_and_store
      releases = if cached?
        read_from_cache
      else
        _fetch_and_store
      end
      Release.wrap_many(releases)
    end

    def cached?
      File.exist?(CACHE_FILE_NAME)
    end

    def read_from_cache
      logger.debug { "Re-reading cached file #{CACHE_FILE_NAME}" }
      ::JSON.parse(File.read(CACHE_FILE_NAME), symbolize_names: true)
    end

    def _fetch_and_store
      run.tap do |result|
        raise "Bad releases data; #{result}" if result.any?(&:nil?)
        File.open(CACHE_FILE_NAME, 'w') { |f| f.write(JSON.dump(result)) }
      end
    end

    private

    def run
      logger.info { 'Fetching Releases from Github...' }
      configure_github_client
      fetch_releases
    end

    def validate_options!
      raise Error, ANSI.red { 'Quitting: missing ENV var RELEASE_NOTES_GITHUB_TOKEN. See README.md' } unless @token.present?
    end

    def configure_github_client
      if ENV['OCTOKIT_CA_PATH']
        Octokit.configure do |config|
          config.connection_options = { ssl: { ca_path: ENV['OCTOKIT_CA_PATH'] } }
        end
      end
      Octokit.auto_paginate = true
    end

    def fetch_releases
      Octokit::Client.new(access_token: @token).list_releases(@repo_slug, draft: false)
    end
  end
end
