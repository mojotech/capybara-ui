require 'spec_helper'

describe "Dill::FieldGroup" do
  shared_examples_for 'a field' do
    context 'when using an auto locator' do
      Then { widget(:field_group).visible?(:auto_locator) }
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

    GivenWidget do
      class FieldGroup < Dill::FieldGroup
        root 'body'

        check_box :unchecked_box, 'ub'
        check_box :checked_box, 'cb'
        check_box :auto_locator
      end
    end

    context 'when defining' do
      Then { FieldGroup.field_names.include?(:unchecked_box) }
    end

    context 'when querying' do
      Then { widget(:field_group).checked_box == true }
      Then { widget(:field_group).unchecked_box == false }
    end

    context 'when setting' do
      When { widget(:field_group).checked_box   = false }
      When { widget(:field_group).unchecked_box = true }

      Then { widget(:field_group).checked_box   == false }
      Then { widget(:field_group).unchecked_box == true }
    end

    context 'when transforming to table' do
      Given(:headers) {['unchecked box', 'checked box', 'auto locator']}
      Given(:values)  {['no', 'yes', 'no']}

      When(:table)   { widget(:field_group).to_table }

      Then { table == [headers, values] }
    end

    it_should_behave_like 'a field'
  end

  describe '.select' do
    GivenHTML <<-HTML
      <p>
        <label for="u">Unselected</label>
        <select name="u" id="u">
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

    GivenWidget do
      class FieldGroup < Dill::FieldGroup
        root 'body'

        select :unselected, 'u'
        select :selected, 's'
        select :by_value, 'v'
        select :auto_locator
      end
    end

    context 'when defining' do
      Then { FieldGroup.field_names.include?(:unselected) }
    end

    context 'when querying' do
      Then { widget(:field_group).unselected == 'One' }
      Then { widget(:field_group).selected == 'Selected option' }
    end

    context 'when setting' do
      When { widget(:field_group).unselected = 'Two' }
      When { widget(:field_group).selected   = 'Unselected option' }
      When { widget(:field_group).by_value   = 't'}

      Then { widget(:field_group).unselected == 'Two' }
      Then { widget(:field_group).selected   == 'Unselected option' }
      Then { widget(:field_group).by_value   == 't' }
    end

    context 'when transforming to table' do
      Given(:headers) {['unselected', 'selected', 'by value', 'auto locator']}
      Given(:values)  {['one', 'selected option', 'o', '']}

      When(:table)   { widget(:field_group).to_table }

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

    GivenWidget do
      class FieldGroup < Dill::FieldGroup
        root 'body'

        text_field :empty_field, 'ef'
        text_field :filled_field, 'ff'
        text_field :auto_locator
      end
    end

    context 'when defining' do
      Then { FieldGroup.field_names.include?(:empty_field) }
    end

    context 'when querying' do
      Then { widget(:field_group).empty_field.nil? }
      Then { widget(:field_group).filled_field == 'Field contents' }
    end

    context 'when setting' do
      When { widget(:field_group).empty_field  = 'Some text' }
      When { widget(:field_group).filled_field = nil }

      Then { widget(:field_group).empty_field  == 'Some text' }
      Then { widget(:field_group).filled_field == '' }
    end

    describe '#to_table' do
      Given(:table)   { widget(:field_group).to_table }
      Given(:headers) {['empty field', 'filled field', 'auto locator']}
      Given(:values)  {['', 'field contents', '']}

      Then { table == [headers, values] }
    end

    it_should_behave_like 'a field'
  end
end
