require 'pathname'
module GithubReleaseNotes
  class HtmlFormatter < Formatter
    def call
      return unless configured_to_write_to(config.html_output)

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

    def format
      html_template_data = config.html_template_data
      ERB.new(File.read(templates_path + 'html_full.html.erb')).result(binding).force_encoding('UTF-8')
    end
  end
end
