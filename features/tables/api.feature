Feature: API

  To use a Table widget, you will sometimes need to define what a row is, and what a column is. You do that using the `header_row`, `data_row` and `column` macros.

  Background:

    Given the following HTML:
      """
      <ul class="table">
        <li class="header-row">
          <span>Col 1</span>
          <span>Col 2</span>
          <span>Col 3</span>
        </li>
        <li class="data-row">
          <span>Val 1.1</span>
          <span>Val 1.2</span>
          <span>Val 1.3</span>
        </li>
        <li class="data-row">
          <span>Val 2.1</span>
          <span>Val 2.2</span>
          <span>Val 2.3</span>
        </li>
        <li class="data-row">
          <span>Val 3.1</span>
          <span>Val 3.2</span>
          <span>Val 3.3</span>
        </li>
      </table>
      """
    And the following widget definition:
      """
      class ListTable < Capybara::UI::Table
        root '.table'

        header_row '.header-row' do
          column 'span'
        end

        data_row '.data-row' do
          column 'span'
        end
      end
      """

  Scenario: Root selector

    Then we can see the widget is present using:
      """
      visible?(:list_table) #=> true
      """

  Scenario: Getting row values

    Then we can get the row values using:
      """
      widget(:list_table).rows[0] #=> ['Val 1.1', 'Val 1.2', 'Val 1.3']
      """

  Scenario: Getting column values by column index

    Then we can get the column values using:
      """
      widget(:list_table).columns[2] #=> ['Val 1.3', 'Val 2.3', 'Val 3.3']
      """

  Scenario: Getting column values by header name

    Then we can get the column values using:
      """
      widget(:list_table).columns['Col 2'] #=> ['Val 1.2', 'Val 2.2', 'Val 3.2']
      """
