require 'spec_helper'

DRIVERS.each do |driver|
  describe "Capybara::UI::CheckBox (#{driver})", driver: driver do
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
        <label for="al">Label locator</label>
        <input type="checkbox" name="ll" id="ll">
      </p>
      <p>
        <label for="al">Auto locator</label>
        <input type="checkbox" name="auto_locator" id="al">
      </p>
    HTML

    GivenWidget do
      class FieldGroup < Capybara::UI::FieldGroup
        root 'body'

        check_box :unchecked_box, 'ub'
        check_box :checked_box, 'cb'
        check_box :label_locator, 'Label locator'
        check_box :auto_locator
      end
    end

    context 'when defining' do
      Then { FieldGroup.field_names.include?(:unchecked_box) }
    end

    context 'when querying' do
      Then { widget(:field_group).checked_box == true }
      Then { widget(:field_group).unchecked_box == false }
      Then { widget(:field_group).label_locator == false }
      Then { widget(:field_group).auto_locator == false }
    end

    context 'when setting' do
      When { widget(:field_group).checked_box   = false }
      When { widget(:field_group).unchecked_box = true }
      When { widget(:field_group).label_locator = true }
      When { widget(:field_group).auto_locator = true }

      Then { widget(:field_group).checked_box   == false }
      Then { widget(:field_group).unchecked_box == true }
      Then { widget(:field_group).label_locator == true }
      Then { widget(:field_group).auto_locator == true }
    end

    context 'when transforming to table' do
      Given(:headers) {['unchecked box', 'checked box', 'label locator', 'auto locator']}
      Given(:values)  {['no', 'yes', 'no', 'no']}

      When(:table)   { widget(:field_group).to_table }

      Then { table == [headers, values] }
    end

    it_should_behave_like 'a field'
  end
end
