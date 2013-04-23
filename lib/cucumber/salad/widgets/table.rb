module Cucumber
  module Salad
    module Widgets
      class Table < Widget
        def self.row_class
          Row
        end

        def to_table
          [headers, *rows.map { |r| Array(r) }]
        end

        private

        def header_for(node)
          node.text.strip.downcase
        end

        def header_selector
          'thead th'
        end

        def headers
          items(header_selector, :header_for)
        end

        def items(selector, builder)
          root.all(selector).map { |e| send(builder, e) }
        end

        def row_factory
          self.class.row_class
        end

        def row_for(node)
          row_factory.new(root: node)
        end

        def row_selector
          'tbody tr'
        end

        def rows
          items(row_selector, :row_for)
        end

        class Row < Widget
          def self.cell(name, selector, type = Atom, &block)
            widget name, selector, type, &block

            cells << name
          end

          def self.cells
            @cells ||= []
          end

          def to_a
            declared_row || generated_row
          end

          protected

          def cell_selector
            'td'
          end

          def declared_row
            cells = self.class.cells

            cells.map { |c| send(c).to_s } if cells.present?
          end

          def generated_row
            root.all(cell_selector).map { |c| c.text.strip }
          end
        end
      end
    end
  end
end
