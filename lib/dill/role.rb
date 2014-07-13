module Dill
  class Role < Dill::Rails::Role
    include Dill::DSL

    def visit(path)
      Capybara.current_session.visit path
    end
  end
end
