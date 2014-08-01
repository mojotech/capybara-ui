# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'dill/version'

Gem::Specification.new do |s|
  s.name          = "dill"
  s.version       = Dill::VERSION
  s.authors       = ["David Leal"]
  s.email         = ["dleal@mojotech.com"]
  s.homepage      = "https://github.com/mojotech/dill"
  s.summary       = "A set of helpers to ease integration testing"
  s.description   = "See https://github.com/mojotech/dill/README.md"
  s.license       = "MIT"

  s.files         = `git ls-files app lib`.split("\n")
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.rubyforge_project = '[none]'

  s.add_dependency 'chronic'
  s.add_dependency 'capybara', '>= 2.0'
  s.add_dependency 'rspec', '< 3.0.0'

  s.add_development_dependency 'rspec-given', '~> 3.0.0'
  s.add_development_dependency 'capybara-webkit', '~> 1.0.0'
  s.add_development_dependency 'poltergeist', '~> 1.3.0'
  s.add_development_dependency 'cucumber', '~> 1.3.0'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'pry-nav'
  s.add_development_dependency 'sinatra'
  s.add_development_dependency 'rails', '~> 4.0.0'
  s.add_development_dependency 'codeclimate-test-reporter'
end
