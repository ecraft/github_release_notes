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
      html_preamble
      html_epilogue
      html_content
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
      body = Kramdown::Document.new(rendered_markdown, input: 'GFM').to_html

      "#{preamble}#{body}#{epilogue}".force_encoding('UTF-8')
    end
  end
end
