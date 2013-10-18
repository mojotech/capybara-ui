require 'spec_helper'

describe Dill::FieldGroup do
  shared_examples_for 'a field' do
    context 'when using an auto locator' do
      Then { w.has_widget?(:auto_locator) }
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

    GivenWidget Dill::FieldGroup do
      check_box :unchecked_box, 'ub'
      check_box :checked_box, 'cb'
      check_box :auto_locator
    end

    context 'when defining' do
      Then { w_class.field_names.include?(:unchecked_box) }
    end

    context 'when querying' do
      Then { w.checked_box == true }
      Then { w.unchecked_box == false }
    end

    context 'when setting' do
      When { w.checked_box   = false }
      When { w.unchecked_box = true }

      Then { w.checked_box   == false }
      Then { w.unchecked_box == true }
    end

    context 'when transforming to table' do
      Given(:headers) {['unchecked box', 'checked box', 'auto locator']}
      Given(:values)  {['no', 'yes', 'no']}

      When(:table)   { w.to_table }

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
        <label for="v">By Value</label>
        <select name="v" id="v">
          <option value="o">One</option>
          <option value="t">Two</option>
        </select>
      </p>
      <p>
        <label for="al">Auto locator</label>
        <select name="al" id="al">
        </select>
      </p>
    HTML

    GivenWidget Dill::FieldGroup do
      select :deselected, 'd'
      select :selected, 's'
      select :by_value, 'v'
      select :auto_locator
    end

    context 'when defining' do
      Then { w_class.field_names.include?(:deselected) }
    end

    context 'when querying' do
      Then { w.deselected.nil? }
      Then { w.selected == 'Selected option' }
    end

    context 'when setting' do
      When { w.selected   = 'Unselected option' }
      When { w.deselected = 'One' }
      When { w.by_value   = 't'}

      Then { w.selected   == 'Unselected option' }
      Then { w.deselected == 'One' }
      Then { w.by_value   == 'Two' }
    end

    context 'when transforming to table' do
      Given(:headers) {['deselected', 'selected', 'by value', 'auto locator']}
      Given(:values)  {['', 'selected option', '', '']}

      When(:table)   { w.to_table }

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

    GivenWidget Dill::FieldGroup do
      text_field :empty_field, 'ef'
      text_field :filled_field, 'ff'
      text_field :auto_locator
    end

    context 'when defining' do
      Then { w_class.field_names.include?(:empty_field) }
    end

    context 'when querying' do
      Then { w.empty_field.nil? }
      Then { w.filled_field == 'Field contents' }
    end

    context 'when setting' do
      When { w.empty_field  = 'Some text' }
      When { w.filled_field = nil }

      Then { w.empty_field  == 'Some text' }
      Then { w.filled_field == '' }
    end

    describe '#to_table' do
      Given(:table)   { w.to_table }
      Given(:headers) {['empty field', 'filled field', 'auto locator']}
      Given(:values)  {['', 'field contents', '']}

      Then { table == [headers, values] }
    end

    it_should_behave_like 'a field'
  end
end
