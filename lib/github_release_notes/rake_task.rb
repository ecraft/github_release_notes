require 'rake'
require 'rake/tasklib'
require 'github_release_notes'

module GithubReleaseNotes
  class RakeTask < ::Rake::TaskLib
    include ::Rake::DSL if defined?(::Rake::DSL)

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
        cfg = {
          verbose: true,
          token: ENV['RELEASE_NOTES_GITHUB_TOKEN'],
          repo_slug: '',
          preamble_template_data: { title: 'Release Notes' },
          epilogue_template_data: {},
          html_output: @target_html_file,
          markdown_output: @target_markdown_file,
          templates_path: GithubReleaseNotes::Formatter::DEFAULT_TEMPLATE_PATH,
          skipped_release_prefixes: []
        }

        # Overrides from the Rake config block from the user
        OPTIONS.each do |o|
          v = instance_variable_get("@#{o}")
          cfg[o.to_sym] = v unless v.nil?
        end
        CLEAN.include [@target_html_file, @target_markdown_file]

        puts ::ANSI.green { 'Generating GitHub Release Notes...' } if cfg[:verbose]

        config = GithubReleaseNotes::Configuration.new(cfg)

        all_releases = GithubReleaseNotes::Fetcher.new(config).fetch_and_store
        releases = all_releases.reject do |r|
          config.skipped_release_prefixes.any? { |prefix| r[:tag_name].start_with?(prefix) }
        end

        GithubReleaseNotes::Formatter.new(releases, config).call

        puts ANSI.green { 'Built GitHub Release Notes.' } if cfg[:verbose]
      end
    end
  end
 end
