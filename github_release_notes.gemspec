# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'github_release_notes/version'

Gem::Specification.new do |spec|
  spec.name          = 'github_release_notes'
  spec.version       = GithubReleaseNotes::VERSION
  spec.authors       = ['Olle Jonsson']
  spec.email         = ['olle.jonsson@ecraft.com']

  spec.summary       = 'Generate end-user-facing release notes from GitHub Releases.'
  spec.description   = 'When you need a separate document for users.'
  spec.homepage      = 'https://github.com/ecraft/github_release_notes'

  spec.metadata['allowed_push_host'] = "https://gems.fury.io"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'ansi', '>= 1.5'
  spec.add_runtime_dependency 'octokit', '>= 4.2'
  spec.add_runtime_dependency 'kramdown', '>= 1.9'
  spec.add_runtime_dependency 'activesupport', '>= 4'
  spec.add_runtime_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'gemfury', '>= 0.6'
end
