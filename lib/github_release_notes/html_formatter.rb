require 'pathname'
module GithubReleaseNotes
  class HtmlFormatter < Formatter
    attr_reader :rendered_html
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
        logger.debug "No Markdown inserted. Can not render HTML output."
        true
      elsif !configured_to_write_to(config.html_output)
        true
      else
        false
      end
    end

    def format
      format_releases_in_html
      html_preamble
      html_epilogue
      html_content
    end

    def format_releases_in_html
      @rendered_html = Kramdown::Document.new(rendered_markdown, input: 'GFM').to_html
    end

    def html_preamble
      data = config.preamble_template_data
      @preamble = ERB.new(File.read(templates_path + 'html_preamble.html.erb')).result(binding)
    end

    def html_epilogue
      data = config.epilogue_template_data
      @epilogue = ERB.new(File.read(templates_path + 'html_epilogue.html.erb')).result(binding)
    end

    def html_content
      "#{preamble}#{rendered_html}#{epilogue}".force_encoding('UTF-8')
    end
  end
end
