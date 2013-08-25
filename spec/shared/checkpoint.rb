shared_examples_for 'checkpoint' do
  context "when condition is not met due to a swallowed exception" do
    When(:result) { checkpoint.wait_for { raise StandardError } }

    Then { result == Failure(StandardError) }
    Then { elapsed > wait_time }
  end

  context "when condition is not met due to being falsey" do
    When(:result) { checkpoint.wait_for { false } }

    Then { result == Failure(Dill::Checkpoint::ConditionNotMet) }
    Then { elapsed > wait_time }
  end

  context "when some unhandled exception is raised" do
    When(:result) { checkpoint.wait_for { raise Exception } }

    Then { result == Failure(Exception) }
    Then { elapsed < wait_time }
  end

  context "when condition is met" do
    When(:result) { checkpoint.wait_for { 'return value' } }

    Then { result == 'return value' }
    Then { elapsed < wait_time }
  end

  context "when condition is met later" do
    Given(:wait_time)   { 3 }
    Given(:break_time) { 1 }

    When(:result) { checkpoint.wait_for { elapsed > break_time } }

    Then { result == true }
    Then { elapsed > break_time }
    Then { elapsed < wait_time }
  end
end
