require 'spec_helper'

DRIVERS.each do |driver|
  describe "Capybara::UI::Select (#{driver})", driver: driver do
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
          <option value="1s" selected>Selected option</option>
          <option value="2s">Unselected option</option>
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
        <label for="ll">Label locator</label>
        <select name="ll" id="ll">
          <option>One</option>
          <option>Two</option>
        </select>
      </p>
      <p>
        <label for="u">Auto locator</label>
        <select name="auto_locator" id="al">
          <option>One</option>
          <option>Two</option>
        </select>
      </p>
    HTML

    GivenWidget do
      class FieldGroup < Capybara::UI::FieldGroup
        root 'body'

        select :unselected, 'u'
        select :selected, 's'
        select :by_value, 'v'
        select :label_locator, 'Label locator'
        select :auto_locator
      end
    end

    context 'when defining' do
      Then { FieldGroup.field_names.include?(:unselected) }
    end

    context 'when querying' do
      Then { widget(:field_group).unselected == 'One' }
      Then { widget(:field_group).selected == 'Selected option' }
      Then { widget(:field_group).selected_value == '1s' }
      Then { widget(:field_group).label_locator == 'One' }
      Then { widget(:field_group).auto_locator == 'One' }
    end

    context 'when setting' do
      When { widget(:field_group).unselected = 'Two' }
      When { widget(:field_group).selected   = 'Unselected option' }
      When { widget(:field_group).by_value   = 't'}
      When { widget(:field_group).label_locator = 'Two' }
      When { widget(:field_group).auto_locator = 'Two' }

      Then { widget(:field_group).unselected == 'Two' }
      Then { widget(:field_group).selected   == 'Unselected option' }
      Then { widget(:field_group).by_value   == 'Two' }
      Then { widget(:field_group).label_locator == 'Two' }
      Then { widget(:field_group).auto_locator == 'Two' }
    end

    context 'when transforming to table' do
      Given(:headers) {['unselected', 'selected', 'by value', 'label locator', 'auto locator']}
      Given(:values)  {['one', 'selected option', 'one', 'one', 'one']}

      When(:table)   { widget(:field_group).to_table }

      Then { table == [headers, values] }
    end

    it_should_behave_like 'a field'
  end
end
