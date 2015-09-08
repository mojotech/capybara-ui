require 'cucumber/ast/table'
require 'spec_helper'

DRIVERS.each do |driver|
  describe "Form diff'ing (#{driver})", driver: driver do
    GivenHTML <<-HTML
      <form>
        <input type="text" name="name" value="Guybrush Threepwood">
        <input type="checkbox" name="protagonist" checked>
        <select name="selected-item">
          <option selected>Wimpy Little Idol</option>
          <option>Leaflet</option>
          <option>Banana Picker</option>
        </select>
      </form>
    HTML

    describe "with #diff", driver: driver do
      GivenWidget do
        class MyWidget < Dill::Form
          root 'form'

          text_field :name, 'name'
          check_box :protagonist, 'protagonist'
          select :selected_item, 'selected-item'
        end
      end

      Given(:base_fields) {
        {
         'name' => 'Guybrush Threepwood',
         'protagonist' => 'yes',
         'selected_item' => 'Wimpy Little Idol'
        }
      }

      Given(:table) { Cucumber::Ast::Table.new([fields]) }

      context "same table" do
        Given(:fields) { base_fields }

        When(:result) { widget(:my_widget).diff table }

        Then { result == true }
      end

      context "different table" do
        Given(:fields) { base_fields.merge('protagonist' => 'no') }

        When(:result) { widget(:my_widget).diff table }

        Then { result == Failure(Cucumber::Ast::Table::Different) }
      end
    end

    describe "with #easy_diff" do
      GivenWidget do
        class MyWidget < Dill::Form
          root 'form'

          text_field :name, 'name'
          check_box :protagonist, 'protagonist'
          select :selected_item, 'selected-item'
        end
      end

      Given(:base_fields) {
        {
         'name' => 'gUybRush thReePwood',
         'protagonist' => 'YES',
         'selected_item' => 'wimpy liTTle idOL'
        }
      }

      Given(:table) { Cucumber::Ast::Table.new([fields]) }

      context "similar table" do
        Given(:fields) { base_fields }

        When(:result) { widget(:my_widget).easy_diff table }

        Then { result == true }
      end

      context "different table" do
        Given(:fields) { base_fields.merge('protagonist' => 'no') }

        When(:result) { widget(:my_widget).easy_diff table }

        Then { result == Failure(Cucumber::Ast::Table::Different) }
      end
    end
  end
end
