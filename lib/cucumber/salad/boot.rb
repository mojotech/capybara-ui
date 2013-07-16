require 'cucumber/salad'

World(Cucumber::Salad::DSL)

module Salad
  include Cucumber::Salad::Widgets

  DSL = Cucumber::Salad::DSL
end
