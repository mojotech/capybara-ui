require 'spec_helper'

describe Cucumber::Salad::Widgets::FieldGroup do
  GivenHTML <<-HTML
    <form>
      <p>
        <label for="cb">Unchecked box</label>
        <input type="checkbox" name="ub" id="ub">
      </p>
      <p>
        <label for="t">Empty field</label>
        <input type="text" name="ef" id="ef">
      </p>
      <p>
        <label for="d">Deselected</label>
        <select name="d" id="d">
          <option>One</option>
        </select>
      </p>
      <p>
        <label for="cb">Checked box</label>
        <input type="checkbox" name="cb" id="cb" checked>
      </p>
      <p>
        <label for="ff">Filled field</label>
        <input type="text" name="ff" id="ff" value="Field contents">
      </p>
      <p>
        <label for="s">Selected</label>
        <select name="s" id="s">
          <option selected>Selected option</option>
          <option>Unselected option</option>
        </select>
      </p>
    </form>
  HTML

  class TestGroup < Cucumber::Salad::Widgets::FieldGroup
    root 'form'

    check_box  :unchecked_box, 'ub'
    select     :deselected, 'd'
    text_field :empty_field, 'ef'
    check_box  :checked_box, 'cb'
    select     :selected, 's'
    text_field :filled_field, 'ff'
  end

  Given(:root)  { find('form') }
  Given(:group) { TestGroup.new(root: root) }

  describe '.check_box' do
    context "when defining" do
      Then { TestGroup.field_names.include?(:unchecked_box) }
    end

    context "when querying" do
      Then { group.checked_box == true }
      Then { group.unchecked_box == false }
    end
  end

  describe '.select' do
    context "when defining" do
      Then { TestGroup.field_names.include?(:deselected) }
    end

    context "when querying" do
      Then { group.deselected.nil? }
      Then { group.selected == "Selected option" }
    end
  end

  describe '.text_field' do
    context "when defining" do
      Then { TestGroup.field_names.include?(:empty_field) }
    end

    context "when querying" do
      Then { group.empty_field.nil? }
      Then { group.filled_field == "Field contents" }
    end
  end
end
