require 'delegate'

module GithubReleaseNotes
  # Data class for one GitHub Release data item from {https://developer.github.com/v3/repos/releases/ the GitHub API v3}.
  class Release < SimpleDelegator
    def self.wrap_many(releases)
      releases.map { |r| new(r) }
    end

    def initialize(release)
      super
      self[:tag_name] = self[:tag_name].to_s
      self[:markdown_body] = harmonize_markdown(self[:body])
      self[:html_body] = markdown_to_html(self[:markdown_body])
    end

    # Name the Release, defaults to `_untitled_` if empty.
    def name
      return '_untitled_' if self[:name].blank?
      self[:name]
    end

    # The text body of the Release, unchanged.
    def body
      self[:body]
    end

    # The body of the Release, as washed Markdown
    def markdown_body
      self[:markdown_body]
    end

    # The text body of the Release, rendered as HTML
    def html_body
      self[:html_body]
    end

    # Note: published_at is a Time
    def published_at_date
      self[:published_at].to_s.split.first
    end

    # The target branch/release series of this Release
    def target_commitish
      self[:target_commitish]
    end

    # URL to the Release on GitHub.com
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

