$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'github_release_notes'
require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end
