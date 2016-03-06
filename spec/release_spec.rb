

module GithubReleaseNotes
  describe Release do
    let(:body) do
      <<EOF
## Notes

* 123
* 234
* 345
EOF
    end
    let(:release) do
      {
        tag_name: 'v1.0.0',
        body: body,
        name: '',
        published_at: '2016-03-06 17:51:45 +0100'
      }
    end

    it 'conveniently wraps many Hashes with .wrap_many' do
      result = described_class.wrap_many([release])

      expect(result.first).to be_a(Release)
    end

    it 'defaults to a visible italicized Markdown name for unnamed releases' do
      result = Release.new(release)

      expect(result.name).to eq('_untitled_')
    end

    it 'formats incoming Markdown to HTML' do
      result = Release.new(release)

      expect(result.html_body).to include('<h2 id="notes">Notes</h2>')
    end

    it 'adds #published_at_date for easier formatting' do
      result = Release.new(release)

      expect(result.published_at_date).to eq('2016-03-06')
    end

    it 'ensures PR link lists are represented using harmonious Markdown' do
      result = Release.new(release)

      expect(result.markdown_body).not_to include('* 123')
      expect(result.markdown_body).to include('- \#123')
    end
  end
end
