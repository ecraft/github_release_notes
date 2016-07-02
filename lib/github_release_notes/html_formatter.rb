require 'pathname'
module GithubReleaseNotes
  class HtmlFormatter < Formatter
    attr_accessor :rendered_markdown

    def call
      return if must_skip_rendering!

      File.open(config.html_output, 'w') do |f|
        f.write(format)
      end
      logger.info { "Generated #{config.html_output}" }
    end

    private

    def validate_options!
      raise Error, ANSI.red {
        ':html_output must be set to a writable path.' \
        " Current value: #{config.html_output.inspect}"
      } if config.html_output.present? && !configured_to_write_to(config.html_output)
    end

    def must_skip_rendering!
      if rendered_markdown.blank?
        raise Error, ANSI.red { 'No Markdown given. Can not render HTML.' }
      elsif !configured_to_write_to(config.html_output)
        true
      else
        false
      end
    end

    def format
      rendered_releases = Kramdown::Document.new(rendered_markdown, input: 'GFM').to_html
      html_template_data = config.html_template_data
      ERB.new(File.read(templates_path + 'html_full.html.erb')).result(binding).force_encoding('UTF-8')
    end
  end
end
