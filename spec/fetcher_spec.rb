module GithubReleaseNotes
  describe Fetcher do
    let(:empty_config) {
      double('empty_config', token: '', repo_slug: '', logger: '')
    }

    let(:config) {
      double('config', token: '123', repo_slug: 'sky4winder/github-changelog-generator', logger: '')
    }

    it 'validates bad options' do
      expect {
        described_class.new(empty_config)
      }.to raise_error GithubReleaseNotes::Error
    end

    it 'validates good options' do
      expect {
        described_class.new(config)
      }.not_to raise_error
    end
  end
end
