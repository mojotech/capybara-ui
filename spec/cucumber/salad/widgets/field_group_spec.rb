require 'spec_helper'

describe Cucumber::Salad::Widgets::FieldGroup do
  GivenHTML <<-HTML
    <form>
      <input type="checkbox" name="cb">
      <input type="text" name="t">
      <select name="s">
        <option>One</option>
      </select>
    </form>
  HTML

  class TestGroup < Cucumber::Salad::Widgets::FieldGroup
    check_box :checkbox, 'cb'
    select :select, 's'
    text_field :textfield
  end

  describe '.check_box' do
    context "when defining" do
      Then { TestGroup.field_names.include?(:checkbox) }
    end
  end

  describe '.select' do
    context "when defining" do
      Then { TestGroup.field_names.include?(:select) }
    end
  end

  describe '.text_field' do
    context "when defining" do
      Then { TestGroup.field_names.include?(:textfield) }
    end
  end
end
