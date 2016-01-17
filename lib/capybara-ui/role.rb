module Capybara::UI
  class Role < Capybara::UI::Rails::Role
    extend Widgets::DSL

    include Capybara::UI::DSL

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
