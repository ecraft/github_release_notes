module GithubReleaseNotes
  class Formatter
    TEMPLATES = Pathname('rakelib/release_notes_templates')
    RELEASE_TEMPLATE_PATH = TEMPLATES + 'release.md.erb'
    PREAMBLE_PATH = TEMPLATES + 'html_preamble.html.erb'
    EPILOGUE_PATH = TEMPLATES + 'html_epilogue.html.erb'

    attr_reader :releases, :rendered_markdown, :rendered_html,
                :preamble, :epilogue, :preamble_data, :epilogue_data,
                :full_html

    # @param releases [Array<Hash>]
    # @param config [GithubReleaseNotes::Configuration]
    def initialize(releases, config)
      @releases = releases

      @preamble_data = config.preamble_template_data
      @epilogue_data = config.epilogue_template_data
      @html_output = config.html_output
      @markdown_output = config.markdown_output
      validate_options!
    end

    def validate_options!
      can_write_output = [@html_output, @markdown_output].any? do |path|
        configured_to_write_to(path)
      end
      raise ArgumentError, ANSI.red { ':html_output or :markdown_output must be set to writable paths' } unless can_write_output
    end

    def call
      format_markdown
      format_html

      if configured_to_write_to(@markdown_output)
        File.open(@markdown_output, 'w') do |f|
          f.write(rendered_markdown)
        end
        puts ANSI.green { "Generated #{@markdown_output}" }
      end

      if configured_to_write_to(@html_output)
        File.open(@html_output, 'w') do |f|
          f.write(full_html)
        end
        puts ANSI.green { "Generated #{@html_output}" }
      end
    end

    def configured_to_write_to(path)
      path.present? && Pathname(path.to_s).dirname.writable?
    end

    def format_markdown
      @rendered_markdown ||= begin
        release_template = File.read(RELEASE_TEMPLATE_PATH)
        releases.map do |release|
          ERB.new(release_template).result(binding)
        end.join('').force_encoding('UTF-8')
      end
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
      @rendered_html = Kramdown::Document.new(rendered_markdown, {}).to_html
    end

    def process_name(release)
      if release[:name].empty?
        '_untitled_'
      else
        release[:name]
      end
    end

    def process_body(body)
      body.gsub('\r\n', "\r\n").gsub(/^[\-\*] (#)?(\d+)/, '- \#\2')
    end

    def html_preamble
      data = preamble_data
      @preamble = ERB.new(File.read(PREAMBLE_PATH)).result(binding)
    end

    def html_epilogue
      data = epilogue_data
      @epilogue = ERB.new(File.read(EPILOGUE_PATH)).result(binding)
    end

    def html_content
      "#{preamble}#{rendered_html}#{epilogue}".force_encoding('UTF-8')
    end
  end
end
