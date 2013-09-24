require 'spec_helper'

describe Dill::DynamicValue do
  describe "unchanging equality" do
    Given(:value) { Dill::DynamicValue.new { 'b' } }

    Then { value == value }
    Then { value == 'b' }
    Then { ! (value != 'b') }
  end

  describe "delayed equality" do
    Given(:value) { v = 'a'; Dill::DynamicValue.new { v.succ! } }

    Then { value == 'd' }
  end

  describe "unchanging inequality" do
    Given(:value) { Dill::DynamicValue.new { 'b' } }

    Then { value != 'c'}
    Then { ! (value == 'c') }
  end

  describe "delayed inequality" do
    Given(:value) { v = 'a'; Dill::DynamicValue.new { v.succ! } }

    Then { value != 'a' }
  end

  describe "unchanging pattern matching" do
    Given(:value) { Dill::DynamicValue.new { 'b' } }

    Then { value =~ /b/ }
    Then { value !~ /c/ }
  end

  describe "delayed pattern matching" do
    Given(:value) { v = 'a'; Dill::DynamicValue.new { v.succ! } }

    Then { value =~ /f/ }
    Then { value !~ /b/ }
  end

  describe "unchanging delegated comparison" do
    Given(:value) { Dill::DynamicValue.new { 'b' } }

    Then { value < 'c' }
    Then { value > 'a' }
  end

  describe "delayed delegated comparison" do
    Given(:value) { v = 'a'; Dill::DynamicValue.new { v.succ! } }

    Then { value > 'b' }
  end

  describe "inspect value" do
    Given(:value) { Dill::DynamicValue.new { 'b' } }

    When(:inspection) { value.inspect }

    Then { inspection == '"b"' }
  end

  describe "responds to missing" do
    Given(:value) { Dill::DynamicValue.new { 'b' } }

    Then { value.respond_to?(:<) }
  end

  describe "matching" do
    Given(:value) { Dill::DynamicValue.new { 'b' } }

    context "simple match" do
      Then { value.match(/b/) }
    end

    context "match with block" do
      When(:result) { value.match(/b/) { |m| 'w00t!' } }

      Then { result == 'w00t!' }
    end

    context "no match" do
      Then { ! value.match(/No match/) }
    end

    context "no match with position" do
      Then { ! value.match(/b/, 2) }
    end
  end
end
