require 'delegate'

module GithubReleaseNotes
  # Data class for one GitHub Release data item from the GitHub API v3.
  class Release < SimpleDelegator
    def self.wrap_many(releases)
      releases.map { |r| new(r.to_h) }
    end

    def initialize(release)
      super
      self[:tag_name] = self[:tag_name].to_s
      self[:markdown_body] = harmonize_markdown(self[:body])
      self[:html_body] = markdown_to_html(self[:markdown_body])
    end

    def name
      return '_untitled_' if self[:name].blank?
      self[:name]
    end

    def body
      self[:body]
    end

    def html_body
      self[:html_body]
    end

    def markdown_body
      self[:markdown_body]
    end

    def published_at_date
      self[:published_at].split.first
    end

    def target_commitish
      self[:target_commitish]
    end

    def html_url
      self[:html_url]
    end

    private

    def harmonize_markdown(body)
      body.gsub('\r\n', "\r\n")
          .gsub(/^[\-\*] (#)?(\d+)/, '- \#\2')
    end

    def markdown_to_html(body)
      Kramdown::Document.new(body, {}).to_html
    end
  end
end

