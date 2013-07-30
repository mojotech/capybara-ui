require 'spec_helper'

describe Dill::Widgets::FieldGroup do
  shared_examples_for 'a field' do
    context "when using an auto locator" do
      Then { container.has_widget?(:auto_locator) }
    end
  end

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
      <p>
        <label for="al">Auto locator</label>
        <input type="checkbox" name="al" id="al">
      </p>
    HTML

    Given(:container_class) { CheckBoxGroup }

    class CheckBoxGroup < Dill::Widgets::FieldGroup
      check_box :unchecked_box, 'ub'
      check_box :checked_box, 'cb'
      check_box :auto_locator
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
      Given(:headers) {['unchecked box', 'checked box', 'auto locator']}
      Given(:values)  {['no', 'yes', 'no']}

      When(:table)   { container.to_table }

      Then { table == [headers, values] }
    end

    it_should_behave_like 'a field'
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
      <p>
        <label for="al">Auto locator</label>
        <select name="al" id="al">
        </select>
      </p>
    HTML

    Given(:container_class) { SelectGroup }

    class SelectGroup < Dill::Widgets::FieldGroup
      select :deselected, 'd'
      select :selected, 's'
      select :auto_locator
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
      Given(:headers) {['deselected', 'selected', 'auto locator']}
      Given(:values)  {['', 'selected option', '']}

      When(:table)   { container.to_table }

      Then { table == [headers, values] }
    end

    it_should_behave_like 'a field'
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
      <p>
        <label for="al">Auto locator</label>
        <input type="text" name="al" id="al">
      </p>
    HTML

    Given(:container_class) { TextGroup }

    class TextGroup < Dill::Widgets::FieldGroup
      text_field :empty_field, 'ef'
      text_field :filled_field, 'ff'
      text_field :auto_locator
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
      Given(:headers) {['empty field', 'filled field', 'auto locator']}
      Given(:values)  {['', 'field contents', '']}

      Then { table == [headers, values] }
    end

    it_should_behave_like 'a field'
  end
end
