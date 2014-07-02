lib_path = File.expand_path("../../lib")
$LOAD_PATH.unshift lib_path

require 'dill/cucumber'

module Widget
  def self.defined_widgets
    @defined_widgets ||= []
  end

  def clear_widgets
    Widget.defined_widgets.each do |e|
      self.class.send :remove_const, e
    end

    Widget.defined_widgets.clear
  end

  def define_widget(code)
    parent = self.class
    before_consts = parent.constants.dup

    parent.class_eval code

    after_consts = parent.constants

    constants = after_consts - before_consts
    fail "no widget defined" if constants.size == 0
    fail "more than one widget defined" if constants.size > 1

    Widget.defined_widgets << constants.first

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

After do
  clear_widgets
end
