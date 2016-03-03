require 'delegate'
module GithubReleaseNotes
  class Configuration < SimpleDelegator
    def token
      fetch(:token)
    end

    def repo_slug
      fetch(:repo_slug) { raise 'Missing required config option :repo_slug!' }
    end

    def preamble_template_data
      fetch(:preamble_template_data)
    end

    def epilogue_template_data
      fetch(:epilogue_template_data)
    end

    def html_output
      fetch(:epilogue_template_data)
    end

    def markdown_output
      fetch(:markdown_output)
    end

    def skipped_release_prefixes
      fetch(:skipped_release_prefixes)
    end
  end
end

