require 'spec_helper'

DRIVERS.each do |driver|
  describe ".radio_button (#{driver})", driver: driver do
    GivenHTML <<-HTML
      <p class="unchecked">
        <label for="u1">
          <input type="radio" name="u" id="u1" value="1">One
        </label>
        <label for="u2">
          <input type="radio" name="u" id="u2" value="2">Two
        </label>
      </p>
      <p class="checked">
        <label for="c3">Checked</label>
        <input type="radio" name="c" id="c3" value="3" checked>
        <label for="c4">Unchecked</label>
        <input type="radio" name="c" id="c4" value="4">
      </p>
      <p class="by-value">
        <label for="v5">One</label>
        <input type="radio" name="v" id="v5" value="5">
        <label for="v6">Two</label>
        <input type="radio" name="v" id="v6" value="6">
      </p>
      <p class="auto-locator">
        <input type="radio" name="a" id="a7" value="7">
      </p>
    HTML

    GivenWidget do
      class FieldGroup < Dill::FieldGroup
        root 'body'

        radio_button :unchecked, '.unchecked'
        radio_button :checked, '.checked'
        radio_button :by_value, '.by-value'
        radio_button :auto_locator, '.auto-locator'
      end
    end

    context 'when defining' do
      Then { FieldGroup.field_names.include?(:unchecked) }
    end

    context 'when querying' do
      Then { widget(:field_group).unchecked.nil? }
      Then { widget(:field_group).checked == 'Checked' }
    end

    context 'when setting' do
      When { widget(:field_group).unchecked   = 'One' }
      When { widget(:field_group).checked     = 'Unchecked' }
      When { widget(:field_group).by_value    = 'One'}

      Then { widget(:field_group).unchecked   == 'One' }
      Then { widget(:field_group).checked     == 'Unchecked' }
      Then { widget(:field_group).by_value    == 'One' }
    end

    context 'when transforming to table' do
      Given(:headers) {['unchecked', 'checked', 'by value', 'auto locator']}
      Given(:values)  {['', 'checked', '', '']}

      When(:table)   { widget(:field_group).to_table }

      Then { table == [headers, values] }
    end

    it_should_behave_like 'a field'
  end
end
