require 'spec_helper'

describe Dill::AutoTable do
  GivenHTML <<-HTML
    <table>
      <thead>
        <tr>
          <th>Header 1</th>
          <th>Header 2</th>
        </tr>
      <tbody>
        <tr>
          <td>Cell 1a</td>
          <td>Cell 2a</td>
        </tr>
        <tr>
          <td>Cell 1b</td>
          <td>Cell 2b</td>
        </tr>
      </tbody>
      <tfoot>
        <tr>
          <td>Footer 1</td>
          <td>Footer 2</td>
        </tr>
      </tfoot>
    </table>
  HTML

  GivenWidget do
    class Table < Dill::AutoTable
      root 'table'
    end
  end

  Given(:table) {
    [['header 1', 'header 2'],
     ['Cell 1a', 'Cell 2a'],
     ['Cell 1b', 'Cell 2b']]
  }

  Given(:footer) { ['Footer 1', 'Footer 2'] }

  Then { widget(:table).to_table == table }
  Then { widget(:table).footers == footer }
end
