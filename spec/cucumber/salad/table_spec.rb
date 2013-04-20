require 'spec_helper'
require 'ostruct'

describe Cucumber::Salad::Table do
  class ATable < Cucumber::Salad::Table
    map 'passthrough'
    map 'convert header', to: :a_symbol
    map 'full' do |v|
      v.to_i + 1
    end
    map 'full2' do |v|
      Boolean(v)
    end
  end

  class BTable < ATable
    map 'full' do |v|
      v.to_i - 1
    end
  end

  let(:hashes) {
    [{'passthrough'    => 'a_str',
      'convert header' => 'converted',
      'full'           => '2',
      'full2'          => 'yes'}]
  }
  let(:table)  { OpenStruct.new(hashes: hashes) }

  shared_examples_for 'table' do
    it "passes header through" do
      expect(t).to have_key(:passthrough)
    end

    it "returns passthrough value" do
      expect(t[:passthrough]).to eq 'a_str'
    end

    it "converts header" do
      expect(t).to have_key(:a_symbol)
    end

    it "returns converted header value" do
      expect(t[:a_symbol]).to eq 'converted'
    end

    it "converts value with predefined conversion" do
      expect(t[:full2]).to eq true
    end
  end

  describe 'base class' do
    subject(:t) { ATable.new(table).first }

    it_should_behave_like 'table'

    it "converts value" do
      expect(t[:full]).to eq 3
    end
  end

  describe 'subclass' do
    subject(:t) { BTable.new(table).first }

    it_should_behave_like 'table'

    it "converts with overriden conversion" do
      expect(t[:full]).to eq 1
    end
  end
end
