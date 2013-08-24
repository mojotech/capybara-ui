require 'spec_helper'
require 'shared/checkpoint'

describe Dill::Checkpoint do
  Given(:wait_time)  { 1 }
  Given(:checkpoint) { Dill::Checkpoint.new(wait_time) }

  When(:start)  { Time.now }

  it_should_behave_like 'checkpoint'

  def elapsed
    Time.now - start
  end
end
