module GithubReleaseNotes
  class ReleaseNotesTasks
    include Rake::DSL if defined? Rake::DSL

    def install_tasks
      namespace :github_release_notes do
        require 'github_release_notes'
        @target_html_file = 'releases.html'
        @target_markdown_file = 'releases.md'
        CLEAN.include [@target_html_file, @target_markdown_file]

        desc 'Release Notes to Markdown and HTML'
        task :build do
          puts ::ANSI.green { 'Generating GitHub Release Notes...' }

          config = GithubReleaseNotes::Configuration.new({
            token: ENV['RELEASE_NOTES_GITHUB_TOKEN'],
            repo_slug: 'ecraft/ecraft.fieldopsapp',
            preamble_template_data: { title: 'Release Notes' },
            epilogue_template_data: {},
            html_output: @target_html_file,
            markdown_output: @target_markdown_file,
            templates_path: GithubReleaseNotes::Formatter::DEFAULT_TEMPLATE_PATH,
            skipped_release_prefixes: ['il/', 'tst_']
          })

          all_releases = GithubReleaseNotes::Fetcher.new(config.token, config.repo_slug).fetch_and_store
          releases = all_releases.reject do |r|
            config.skipped_release_prefixes.any? { |prefix| r[:tag_name].start_with?(prefix) }
          end
          #releases = yield releases if block_given?

          GithubReleaseNotes::Formatter.new(releases, config).call

          sh "open #{@target_html_file}"

          puts ANSI.green { 'Built GitHub Release Notes.' }
        end
      end
    end
  end
 end

GithubReleaseNotes::ReleaseNotesTasks.new.install_tasks
