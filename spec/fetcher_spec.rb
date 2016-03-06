module GithubReleaseNotes
  describe Fetcher do
    let(:empty_config) do
      double('empty_config', token: '', repo_slug: '', logger: '')
    end

    let(:config) do
      double('config', token: '123', repo_slug: 'sky4winder/github-changelog-generator', logger: '')
    end

    it 'validates bad options' do
      expect do
        described_class.new(empty_config)
      end.to raise_error GithubReleaseNotes::Error
    end

    it 'validates good options' do
      expect do
        described_class.new(config)
      end.not_to raise_error
    end
  end
end
