module Dill
  class Role < Dill::Rails::Role
    extend Widgets::DSL

    include Dill::DSL

    alias_method :see?, :widget?

    def inspect
      self.class.name
    end
  end
end
