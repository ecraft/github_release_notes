module GithubReleaseNotes
  describe Fetcher do
    let(:empty_config) do
      GithubReleaseNotes::Configuration.new(
        token: '',
        repo_slug: '',
        logger: double('logger').as_null_object
      )
    end

    let(:config) do
      GithubReleaseNotes::Configuration.new(
        token: '123',
        repo_slug: 'sky4winder/github-changelog-generator',
        logger: double('logger').as_null_object
      )
    end

    let(:config_without_logger) do
      GithubReleaseNotes::Configuration.new(
        token: '123',
        repo_slug: 'sky4winder/github-changelog-generator'
      )
    end

    it 'validates bad options' do
      expect {
        described_class.new(empty_config)
      }.to raise_error(GithubReleaseNotes::Error)
    end

    it 'complains specifically about missing logger' do
      expect {
        described_class.new(config_without_logger)
      }.to raise_error(ArgumentError)
    end

    it 'validates good options' do
      expect { described_class.new(config) }.not_to raise_error
    end
  end
end
