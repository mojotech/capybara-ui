# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'cucumber/salad/version'

Gem::Specification.new do |s|
  s.name          = "cucumber-salad"
  s.version       = Cucumber::Salad::VERSION
  s.authors       = ["David Leal"]
  s.email         = ["dleal@mojotech.com"]
  s.homepage      = "https://github.com/mojotech/cucumber-salad"
  s.summary       = "A set of helpers to ease writing cucumber features"
  s.description   = "See https://github.com/mojotech/cucumber-salad/README.md"
  s.license       = "MIT"

  s.files         = `git ls-files app lib`.split("\n")
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.rubyforge_project = '[none]'

  s.add_dependency 'cucumber'
  s.add_dependency 'chronic'
  s.add_dependency 'capybara', '>= 2.0'

  s.add_development_dependency 'rspec-given', '~> 3.0.0'
  s.add_development_dependency 'sinatra'
end
