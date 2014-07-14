module Dill
  class Role < Dill::Rails::Role
    extend Widgets::DSL

    include Dill::DSL
  end
end
