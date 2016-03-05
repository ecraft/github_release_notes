module GithubReleaseNotes
  class Formatter
    DEFAULT_TEMPLATE_PATH = File.join(File.dirname(__FILE__), '../../templates')
    attr_reader :releases, :rendered_markdown, :rendered_html,
                :preamble, :epilogue, :config,
                :full_html, :logger

    # @param releases [Array<Hash>]
    # @param config [GithubReleaseNotes::Configuration]
    def initialize(releases, config)
      @releases = releases

      @config = config
      @logger = config.logger
      validate_options!
    end

    def validate_options!
      can_write_output = [config.html_output,
                          config.markdown_output].any? do |path|
        configured_to_write_to(path)
      end

      raise Error, ANSI.red {
        ':html_output or :markdown_output must be set to writable paths'
      } unless can_write_output
    end

    def call
      format_markdown
      format_html

      if configured_to_write_to(config.markdown_output)
        File.open(config.markdown_output, 'w') do |f|
          f.write(rendered_markdown)
        end
        logger.info { "Generated #{config.markdown_output}" }
      else
        logger.debug "Skipping Markdown output. #{config.markdown_output}"
      end

      if configured_to_write_to(config.html_output)
        File.open(config.html_output, 'w') do |f|
          f.write(full_html)
        end
        logger.info { "Generated #{config.html_output}" }
      else
        logger.debug "Skipping HTML output. #{config.html_output}"
      end
    end

    def configured_to_write_to(path)
      path.present? && Pathname(path.to_s).dirname.writable?
    end

    def format_markdown
      @rendered_markdown ||= begin
        release_template = File.read(release_template_path)

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

    def templates_path
      Pathname(config.templates_path)
    end

    def release_template_path
      templates_path + 'release.md.erb'
    end

    def preamble_template_path
      templates_path + 'html_preamble.html.erb'
    end

    def epilogue_template_path
      templates_path + 'html_epilogue.html.erb'
    end
  end
end
