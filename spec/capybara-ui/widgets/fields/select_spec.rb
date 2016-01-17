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
        <label for="al">Auto locator</label>
        <select name="al" id="al">
        </select>
      </p>
    HTML

    GivenWidget do
      class FieldGroup < Capybara::UI::FieldGroup
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
      Then { widget(:field_group).selected == 'Selected option' }
      Then { widget(:field_group).selected_value == '1s' }
    end

    context 'when setting' do
      When { widget(:field_group).unselected = 'Two' }
      When { widget(:field_group).selected   = 'Unselected option' }
      When { widget(:field_group).by_value   = 't'}

      Then { widget(:field_group).unselected == 'Two' }
      Then { widget(:field_group).selected   == 'Unselected option' }
      Then { widget(:field_group).by_value   == 'Two' }
    end

    context 'when transforming to table' do
      Given(:headers) {['unselected', 'selected', 'by value', 'auto locator']}
      Given(:values)  {['one', 'selected option', 'one', '']}

      When(:table)   { widget(:field_group).to_table }

      Then { table == [headers, values] }
    end

    it_should_behave_like 'a field'
  end
end
