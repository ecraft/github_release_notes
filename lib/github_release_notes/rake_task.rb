require 'rake'
require 'rake/tasklib'
require 'github_release_notes'
require 'logger'

module GithubReleaseNotes
  class RakeTask < ::Rake::TaskLib
    include ::Rake::DSL if defined?(::Rake::DSL)

    # Rake task configuration accessors available in the block
    OPTIONS = %w(
      verbose
      target_html_file
      target_markdown_file
      token
      repo_slug
      preamble_template_data
      epilogue_template_data
      html_output
      markdown_output
      templates_path
      skipped_release_prefixes
      logger
      log_level
      filter_lambda
    ).freeze

    OPTIONS.each do |o|
      attr_accessor o.to_sym
    end

    # Initialise a new GithubReleaseNotes::RakeTask.
    #
    # Example
    #
    #   GithubReleaseNotes::RakeTask.new
    def initialize(*args, &task_block)
      @name = args.shift || :build_release_notes

      define(args, &task_block)
    end

    def define(args, &task_block)
      desc 'Generate Release Notes from GitHub'

      yield(*[self, args].slice(0, task_block.arity)) if task_block

      # clear any (auto-)pre-existing task
      Rake::Task[@name].clear if Rake::Task.task_defined?(@name)

      task @name do
        colors = {
          "FATAL" => :red,
          "ERROR" => :red,
          "WARN"  => :yellow,
          "INFO"  => :green,
          "DEBUG" => :white,
        }
        default_logger = Logger.new($stdout)
        default_logger.formatter = ->(severity, datetime, progname, message) {
          if $stdout.tty?
            colorizer = $stdout.tty? ? colors[severity] : ->(s){s}
            ANSI.send(colors[severity]) { "#{severity}: " } + "#{message}\n"
          else
            "#{severity}: #{message}\n"
          end
        }

        cfg = {
          token: ENV['RELEASE_NOTES_GITHUB_TOKEN'],
          repo_slug: '',
          preamble_template_data: { title: 'Release Notes' },
          epilogue_template_data: {},
          html_output: @target_html_file,
          markdown_output: @target_markdown_file,
          templates_path: GithubReleaseNotes::Formatter::DEFAULT_TEMPLATE_PATH,
          skipped_release_prefixes: [],
          logger: default_logger,
          filter_lambda: ->(rs) { rs }
        }

        # Overrides from the Rake config block from the user
        OPTIONS.each do |o|
          v = instance_variable_get("@#{o}")
          cfg[o.to_sym] = v unless v.nil?
        end

        CLEAN.include [@target_html_file, @target_markdown_file]

        config = GithubReleaseNotes::Configuration.new(cfg)
        logger = config.logger
        logger.info { 'Generating GitHub Release Notes...' }
        logger.level = cfg[:log_level] || Logger::INFO

        all_releases = GithubReleaseNotes::Fetcher.new(config).fetch_and_store
        releases = all_releases.reject do |r|
          config.skipped_release_prefixes.any? { |prefix| r[:tag_name].start_with?(prefix) }
        end
        releases = filter_lambda.call(releases) if filter_lambda.respond_to?(:call)

        GithubReleaseNotes::Formatter.new(releases, config).call

        logger.info { 'Built GitHub Release Notes.' }
      end
    end
  end
 end
