module GithubReleaseNotes
  class Fetcher
    CACHE_FILE_NAME = '.github_releases.json'.freeze

    def initialize(config)
      @token = config.token
      @repo_slug = config.repo_slug
      @verbose = config.verbose
      validate_options!
    end

    def validate_options!
      raise ANSI.red { 'Quitting: missing ENV var RELEASE_NOTES_GITHUB_TOKEN. See README.md' } unless @token.present?
    end

    def run
      puts ANSI.green { 'Fetching Releases from Github...' } if @verbose
      configure_github_client
      fetched_content = fetch_releases
      curate_content(fetched_content)
    end

    def fetch_and_store
      if File.exist?(CACHE_FILE_NAME)
        puts ANSI.yellow { "Re-reading cached file #{CACHE_FILE_NAME}" } if @verbose
        ::JSON.parse(File.read(CACHE_FILE_NAME), symbolize_names: true)
      else
        run.tap do |result|
          raise "Bad releases data; #{result}" if result.any?(&:nil?)
          File.open(CACHE_FILE_NAME, 'w') { |f| f.write(JSON.dump(result)) }
        end
      end
    end

    def configure_github_client
      if ENV['OCTOKIT_CA_PATH']
        Octokit.configure do |config|
          config.connection_options = { ssl: { ca_path: ENV['OCTOKIT_CA_PATH'] } }
        end
      end
      Octokit.auto_paginate = true
    end

    private

    def fetch_releases
      Octokit::Client.new(access_token: @token).list_releases(@repo_slug, draft: false)
    end

    def curate_content(releases)
      releases.map do |r|
        r.to_h.slice(:html_url,         # Link to GitHub
                     :tag_name,         # 2014.1.29
                     :name,             # 2014.1.29
                     :target_commitish, # 2014.1
                     :created_at,
                     :published_at,
                     :body).tap do |item| # Markdown
          item[:tag_name] = item[:tag_name].to_s
        end
      end
    end
  end
end
