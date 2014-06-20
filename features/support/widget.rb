lib_path = File.expand_path("../../lib")
$LOAD_PATH.unshift lib_path

require 'dill/cucumber'

module Widget
  def define_widget(code)
    parent = self.class
    before_consts = parent.constants.dup

    parent.class_eval code

    after_consts = parent.constants

    constants = after_consts - before_consts
    fail "no widget defined" if constants.size == 0
    fail "more than one widget defined" if constants.size > 1

    parent.const_get(constants.first)
  end

  def eval_find(code)
    load_test_page
    eval(code)
  end

  def load_test_page
    visit "/test"
  end
end

World Widget
