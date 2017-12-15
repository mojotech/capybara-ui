# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'capybara/ui/version'

Gem::Specification.new do |s|
  s.name          = "capybara-ui"
  s.version       = Capybara::UI::VERSION
  s.authors       = ["David Leal", "Adam Steel"]
  s.email         = ["dleal@mojotech.com", "ags@mojotech.com"]
  s.homepage      = "https://github.com/mojotech/capybara-ui"
  s.summary       = "A set of helpers to ease integration testing"
  s.description   = "Capybara-UI (formerly called Dill) is a Capybara abstraction that makes it easy to define reuseable DOM \"widgets\", aka page objects, and introduces the concept of \"roles\" to allow you to easily organize your testing methods and widgets. Capybara-UI also introduces helpers and syntactic sugar to make your testing even easier."
  s.license       = "MIT"

  s.files         = `git ls-files app lib`.split("\n")
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.rubyforge_project = '[none]'

  s.add_dependency 'chronic'
  s.add_dependency 'capybara', '~> 2.5'

  s.add_development_dependency 'rspec-given', '~> 3.5.0'
  s.add_development_dependency 'capybara-webkit', '~> 1.7.0'
  s.add_development_dependency 'poltergeist', '~> 1.5.0'
  s.add_development_dependency 'cucumber', '~> 1.3.0'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'pry-nav'
  s.add_development_dependency 'sinatra'
  s.add_development_dependency 'rails', '~> 4.2.9'
  s.add_development_dependency 'codeclimate-test-reporter'
end
