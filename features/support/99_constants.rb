module Constants
  def self.defined_constants
    @defined_constants ||= []
  end

  def clear_constants
    Constants.defined_constants.each do |e|
      self.class.send :remove_const, e
    end

    Constants.defined_constants.clear
  end

  def define_constant(code)
    parent = self.class
    before_consts = parent.constants.dup

    parent.class_eval code

    after_consts = parent.constants

    constants = after_consts - before_consts
    fail "no constant defined" if constants.size == 0
    fail "more than one constant defined" if constants.size > 1

    Constants.defined_constants << constants.first

    parent.const_get(constants.first)
  end
end

World Constants

After do
  clear_constants
end
