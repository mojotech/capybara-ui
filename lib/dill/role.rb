module Dill
  class Role < Dill::Rails::Role
    extend Widgets::DSL

    include Dill::DSL

    alias_method :see?, :widget?
  end
end
