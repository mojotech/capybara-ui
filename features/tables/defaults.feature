Feature: Defaults

  Background:

    Given the following HTML:
      """
      <table>
        <thead>
          <tr>
            <th>Col 1</th>
            <th>Col 2</th>
            <th>Col 3</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>Val 1.1</td>
            <td>Val 1.2</td>
            <td>Val 1.3</td>
          </tr>
          <tr>
            <td>Val 2.1</td>
            <td>Val 2.2</td>
            <td>Val 2.3</td>
          </tr>
          <tr>
            <td>Val 3.1</td>
            <td>Val 3.2</td>
            <td>Val 3.3</td>
          </tr>
        </tbody>
      </table>
      """
    And the following widget definition:
      """
      class DefaultsTable < Dill::Table
      end
      """

  Scenario: Root selector

    By default, the root selector is `table`.

    Then we can see the widget is present using:
      """
      visible?(:defaults_table) #=> true
      """

  Scenario: Getting row values

    By default, the data row selector is `tbody tr`.

    Then we can get the row values using:
      """
      widget(:defaults_table).rows[0] #=> ['Val 1.1', 'Val 1.2', 'Val 1.3']
      """

  Scenario: Getting column values by column index

    By default, the data column selector is `td`

    Then we can get the column values using:
      """
      widget(:defaults_table).columns[2] #=> ['Val 1.3', 'Val 2.3', 'Val 3.3']
      """

  Scenario: Getting column values by header name

    By default, the row header selector is `thead tr` and the column selector is `th`.

    Then we can get the column values using:
      """
      widget(:defaults_table).columns['Col 2'] #=> ['Val 1.2', 'Val 2.2', 'Val 3.2']
      """
