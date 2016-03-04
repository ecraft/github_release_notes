module GithubReleaseNotes
  describe Fetcher do
    let(:empty_config) {
      double('empty_config', token: '', repo_slug: '', logger: '')
    }
    it 'validates options' do
      expect {
        described_class.new(empty_config)
      }.to raise_error GithubReleaseNotes::Error
    end
  end
end
