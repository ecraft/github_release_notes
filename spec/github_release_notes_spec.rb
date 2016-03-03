require 'spec_helper'

describe GithubReleaseNotes do
  it 'has a version number' do
    expect(GithubReleaseNotes::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end
end
