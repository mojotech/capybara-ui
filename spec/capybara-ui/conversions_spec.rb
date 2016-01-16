require 'spec_helper'

describe CapybaraUI::Conversions do
  include CapybaraUI::Conversions

  describe 'Boolean' do
    ['yes', 'true', true].each do |val|
      it "converts #{val.inspect} to true" do
        expect(Boolean(val)).to be true
      end
    end

    ['no', 'false', false, nil].each do |val|
      it "converts #{val.inspect} to false" do
        expect(Boolean(val)).to be false
      end
    end
  end

  describe 'List' do
    it 'converts an empty string to an empty list' do
      expect(List('')).to eq []
    end

    it 'converts a blank string to an empty list' do
      expect(List(' ')).to eq []
    end

    it 'converts a comma separated string to a list' do
      expect(List(' one, two , three four')).to eq ['one', 'two', 'three four']
    end

    it 'transforms a comma separated string to a list' do
      expect(List(' one, two , three four') { |v| "#{v}#{v}"}).
        to eq ['oneone', 'twotwo', 'three fourthree four']
    end
  end

  describe 'Timeish' do
    it 'it converts a timeish string to time' do
      expect(Timeish('1 hour ago')).to be_a(Time)
    end

    [Time.now, Date.today, DateTime.now].each do |v|
      it "it passes on a #{v.class.name}" do
        expect(Timeish(v)).to be_a(v.class)
      end
    end

    it 'converts a formatted date string to Time' do
      expect(Timeish('2013-04-20 15:33:00')).to be_a(Time)
    end
  end
end
