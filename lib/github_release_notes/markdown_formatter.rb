require 'pathname'
module GithubReleaseNotes
  class MarkdownFormatter < Formatter
    attr_reader :rendered_markdown

    def call
      if configured_to_write_to(config.markdown_output)
        format_markdown

        File.open(config.markdown_output, 'w') do |f|
          f.write(rendered_markdown)
        end
        logger.info { "Generated #{config.markdown_output}" }
      else
        logger.debug "Skipping Markdown output. #{config.markdown_output}"
      end
    end

    private

    def validate_options!
      raise Error, ANSI.red {
        ':markdown_output must be set to a writable path.' \
        ". :markdown_output: #{config.markdown_output.inspect}"
      } unless configured_to_write_to(config.markdown_output)
    end

    def format_markdown
      @rendered_markdown ||= begin
        release_template = File.read(release_template_path)

        releases.map do |release|
          ERB.new(release_template).result(binding)
        end.join('').force_encoding('UTF-8')
      end
    end

    def release_template_path
      templates_path + 'release.md.erb'
    end
  end
end
