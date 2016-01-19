require 'spec_helper'

describe Capybara::UI::Checkpoint do
  Given(:wait_time)  { 1 }
  Given(:checkpoint) { Capybara::UI::Checkpoint.new(wait_time) }

  When(:start)  { Time.now }

  describe '#call' do
    context 'when condition is not met due to a swallowed exception' do
      When(:result) { checkpoint.call { raise StandardError } }

      Then { result == Failure(StandardError) }
      Then { elapsed > wait_time }
    end

    context 'when condition is not met due to being falsey' do
      When(:result) { checkpoint.call { false } }

      Then { result == Failure(Capybara::UI::Checkpoint::ConditionNotMet) }
      Then { elapsed > wait_time }
    end

    context 'when some unhandled exception is raised' do
      When(:result) { checkpoint.call { raise Exception } }

      Then { result == Failure(Exception) }
      Then { elapsed < wait_time }
    end

    context 'when condition is met' do
      When(:result) { checkpoint.call { 'return value' } }

      Then { result == 'return value' }
      Then { elapsed < wait_time }
    end

    context 'when condition is met later' do
      Given(:wait_time)   { 3 }
      Given(:break_time) { 1 }

      When(:result) { checkpoint.call { elapsed > break_time } }

      Then { result == true }
      Then { elapsed > break_time }
      Then { elapsed < wait_time }
    end
  end

  def elapsed
    Time.now - start
  end
end
