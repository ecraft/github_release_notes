require 'delegate'
require 'logger'

module GithubReleaseNotes
  class Configuration < SimpleDelegator
    def token
      fetch(:token)
    end

    def repo_slug
      fetch(:repo_slug) do
        raise Error, ANSI.red { 'Missing required config option :repo_slug!' }
      end
    end

    def html_template_data
      fetch(:html_template_data)
    end

    def html_output
      fetch(:html_output)
    end

    def markdown_output
      fetch(:markdown_output)
    end

    def templates_path
      fetch(:templates_path) do
        raise Error, ANSI.red {
          'Missing required config option :templates_path!'
        }
      end
    end

    def skipped_release_prefixes
      fetch(:skipped_release_prefixes)
    end

    def logger
      fetch(:logger) {
        raise ArgumentError, 'Configuration requires a :logger'
      }.tap { |l| l.level = log_level }
    end

    def log_level
      if self[:log_level]
        self[:log_level]
      elsif self[:verbose]
        Logger::DEBUG
      else
        Logger::INFO
      end
    end

    def filter_lambda
      fetch(:filter_lambda)
    end
  end
end
