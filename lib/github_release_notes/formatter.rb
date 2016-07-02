require 'pathname'
require 'forwardable'
module GithubReleaseNotes
  class Formatter
    extend Forwardable

    DEFAULT_TEMPLATE_PATH = File.join(File.dirname(__FILE__), '../../templates')

    attr_reader :releases, :config

    def_delegator :config, :logger

    # @param releases [Array<Hash>]
    # @param config [GithubReleaseNotes::Configuration]
    def initialize(releases, config)
      @releases = releases
      @config = config

      validate_options!
    end

    def configured_to_write_to(path)
      path.present? && Pathname(path.to_s).dirname.writable?
    end

    def templates_path
      Pathname(config.templates_path)
    end

  end
end
