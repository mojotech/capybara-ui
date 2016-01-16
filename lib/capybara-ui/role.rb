module CapybaraUI
  class Role < CapybaraUI::Rails::Role
    extend Widgets::DSL

    include CapybaraUI::DSL

    def see?(name, *args)
      if respond_to?("see_#{name}?")
        send("see_#{name}?", *args)
      else
        visible?(name, *args)
      end
    end

    def inspect
      self.class.name
    end
  end
end
