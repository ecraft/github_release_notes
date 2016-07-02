require 'pathname'
module GithubReleaseNotes
  class MarkdownFormatter < Formatter
    attr_reader :rendered_markdown

    def call
      File.open(config.markdown_output, 'w') do |f|
        f.write(format_markdown)
      end
      logger.info { "Generated #{config.markdown_output}" }
    end

    private

    def validate_options!
      raise Error, ANSI.red {
        ':markdown_output must be set to a writable path.' \
        " Current value: #{config.markdown_output.inspect}"
      } if config.markdown_output.blank? || !configured_to_write_to(config.markdown_output)
    end

    def format_markdown
      @rendered_markdown ||= begin
        release_template = File.read(templates_path + 'release.md.erb')

        releases.map do |release|
          ERB.new(release_template).result(binding)
        end.join('').force_encoding('UTF-8')
      end
    end
  end
end
