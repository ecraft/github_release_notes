require 'pathname'
module GithubReleaseNotes
  class HtmlFormatter < Formatter
    attr_reader :rendered_html, :full_html
    attr_accessor :rendered_markdown

    def call
      if configured_to_write_to(config.html_output)
        format_html

        File.open(config.html_output, 'w') do |f|
          f.write(full_html)
        end
        logger.info { "Generated #{config.html_output}" }
      else
        logger.debug "Skipping HTML output. #{config.html_output}"
      end
    end

    def validate_options!
      raise Error, ANSI.red {
        ':html_output must be set to a writable path.' \
        ". :html_output: #{config.html_output.inspect}"
      } unless configured_to_write_to(config.html_output)
    end

    def format_html
      @full_html ||= begin
        format_releases_in_html
        html_preamble
        html_epilogue
        html_content
      end
    end

    def format_releases_in_html
      @rendered_html = Kramdown::Document.new(rendered_markdown, input: 'GFM').to_html
    end

    def html_preamble
      data = config.preamble_template_data
      @preamble = ERB.new(File.read(preamble_template_path)).result(binding)
    end

    def html_epilogue
      data = config.epilogue_template_data
      @epilogue = ERB.new(File.read(epilogue_template_path)).result(binding)
    end

    def html_content
      "#{preamble}#{rendered_html}#{epilogue}".force_encoding('UTF-8')
    end

    def preamble_template_path
      templates_path + 'html_preamble.html.erb'
    end

    def epilogue_template_path
      templates_path + 'html_epilogue.html.erb'
    end
  end
end
