require 'spec_helper'

describe Cucumber::Salad::Widgets::FieldGroup do
  describe '.check_box' do
    GivenHTML <<-HTML
      <p>
        <label for="cb">Unchecked box</label>
        <input type="checkbox" name="ub" id="ub">
      </p>
      <p>
        <label for="cb">Checked box</label>
        <input type="checkbox" name="cb" id="cb" checked>
      </p>
    HTML

    Given(:container_class) { CheckBoxGroup }

    class CheckBoxGroup < Cucumber::Salad::Widgets::FieldGroup
      check_box :unchecked_box, 'ub'
      check_box :checked_box, 'cb'
    end

    context "when defining" do
      Then { CheckBoxGroup.field_names.include?(:unchecked_box) }
    end

    context "when querying" do
      Then { container.checked_box == true }
      Then { container.unchecked_box == false }
    end

    context "when setting" do
      When { container.checked_box   = false }
      When { container.unchecked_box = true }

      Then { container.checked_box   == false }
      Then { container.unchecked_box == true }
    end

    context 'when transforming to table' do
      Given(:headers) {['unchecked box', 'checked box']}
      Given(:values)  {['no', 'yes']}

      When(:table)   { container.to_table }

      Then { table == [headers, values] }
    end
  end

  describe '.select' do
    GivenHTML <<-HTML
      <p>
        <label for="d">Deselected</label>
        <select name="d" id="d">
          <option>One</option>
          <option>Two</option>
        </select>
      </p>
      <p>
        <label for="s">Selected</label>
        <select name="s" id="s">
          <option selected>Selected option</option>
          <option>Unselected option</option>
        </select>
      </p>
    HTML

    Given(:container_class) { SelectGroup }

    class SelectGroup < Cucumber::Salad::Widgets::FieldGroup
      select :deselected, 'd'
      select :selected, 's'
    end

    context "when defining" do
      Then { SelectGroup.field_names.include?(:deselected) }
    end

    context "when querying" do
      Then { container.deselected.nil? }
      Then { container.selected == "Selected option" }
    end

    context "when setting" do
      When { container.selected   = "Unselected option" }
      When { container.deselected = "One" }

      Then { container.selected   == "Unselected option" }
      Then { container.deselected == "One" }
    end

    context 'when transforming to table' do
      Given(:headers) {['deselected', 'selected']}
      Given(:values)  {['', 'selected option']}

      When(:table)   { container.to_table }

      Then { table == [headers, values] }
    end
  end

  describe '.text_field' do
    GivenHTML <<-HTML
      <p>
        <label for="t">Empty field</label>
        <input type="text" name="ef" id="ef">
      </p>
      <p>
        <label for="ff">Filled field</label>
        <input type="text" name="ff" id="ff" value="Field contents">
      </p>
    HTML

    Given(:container_class) { TextGroup }

    class TextGroup < Cucumber::Salad::Widgets::FieldGroup
      text_field :empty_field, 'ef'
      text_field :filled_field, 'ff'
    end

    context "when defining" do
      Then { TextGroup.field_names.include?(:empty_field) }
    end

    context "when querying" do
      Then { container.empty_field.nil? }
      Then { container.filled_field == "Field contents" }
    end

    context "when setting" do
      When { container.empty_field  = "Some text" }
      When { container.filled_field = nil }

      Then { container.empty_field  == "Some text" }
      Then { container.filled_field == "" }
    end

    describe '#to_table' do
      Given(:table)   { container.to_table }
      Given(:headers) {['empty field', 'filled field']}
      Given(:values)  {['', 'field contents']}

      Then { table == [headers, values] }
    end
  end
end
