lib_path = File.expand_path("../../lib")
$LOAD_PATH.unshift lib_path

require 'dill/cucumber'

module Widget
  def eval_find(code)
    load_test_page
    eval(code)
  end

  alias_method :eval_in_page, :eval_find

  def load_test_page
    visit "/test"
  end
end

World Widget
