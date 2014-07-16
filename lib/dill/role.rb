module Dill
  class Role < Dill::Rails::Role
    extend Widgets::DSL

    include Dill::DSL

    def see?(name, *args)
      if respond_to?("see_#{name}?")
        send("see_#{name}?", *args)
      else
        widget?(name, *args)
      end
    end

    def inspect
      self.class.name
    end
  end
end
