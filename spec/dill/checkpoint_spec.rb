require 'spec_helper'

describe Dill::Checkpoint do
  Given              { Capybara.current_driver = :webkit }
  Given(:wait_time)  { 1 }
  Given(:checkpoint) { Dill::Checkpoint.new(wait_time) }

  When(:start)  { Time.now }

  context "when condition is not met due to element not found" do
    When(:result) { checkpoint.wait_for { raise Capybara::ElementNotFound } }

    Then { result == Failure(Capybara::ElementNotFound) }
    Then { elapsed > wait_time }
  end

  context "when condition is not met due to being falsey" do
    When(:result) { checkpoint.wait_for { false } }

    Then { result == Failure(Dill::Checkpoint::ConditionNotMet) }
    Then { elapsed > wait_time }
  end

  context "when some unhandled exception is raised" do
    When(:result) { checkpoint.wait_for { raise NameError } }

    Then { result == Failure(NameError) }
    Then { elapsed < wait_time }
  end

  context "when condition is met" do
    When(:result) { checkpoint.wait_for { 'return value' } }

    Then { result == 'return value' }
    Then { elapsed < wait_time }
  end

  def elapsed
    Time.now - start
  end
end
