require 'spec_helper'

DRIVERS.each do |driver|
  describe "Dill::TextField (#{driver})", driver: driver do
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
      Then { widget(:field_group).empty_field.empty? }
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
