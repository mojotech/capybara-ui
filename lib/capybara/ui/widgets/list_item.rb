module Capybara
  module UI
    class ListItem < Widget
      # Returns this ListItem's contents formatted as a row, for comparison with a
      # Cucumber::Ast::Table. By default, it simply returns an array with a single
      # element--the widget's text.
      #
      # In general, this method will be called by List#to_table.
      #
      # === Overriding
      #
      # Feel free to override this method to return whatever you need it to.
      # Usually, if the default return value isn't what you want, you'll probably
      # want to return a Hash where both keys and values are strings, so that you
      # don't need to worry about column order when you pass the table to
      # Cucumber::Ast::Table#diff!.
      #
      # See List#to_table for more information.
      def to_row
        [to_cell]
      end
    end
  end
end
