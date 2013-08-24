require 'spec_helper'
require 'shared/checkpoint'

describe Dill::WidgetCheckpoint do
  Given(:wait_time)  { 1 }
  Given(:checkpoint) { Dill::WidgetCheckpoint.new(wait_time) }

  When(:start) { Time.now }

  context "with a driver that doesn't wait" do
    Given { Capybara.current_driver = :rack_test }

    When(:result) { checkpoint.wait_for { false } }

    Then { result == Failure(Dill::Checkpoint::ConditionNotMet) }
    Then { elapsed < wait_time }
  end

  DRIVERS.each do |driver|
    context "with #{driver}" do
      it_should_behave_like 'checkpoint' do
        Given { Capybara.current_driver = driver }
      end
    end
  end

  def elapsed
    Time.now - start
  end
end
