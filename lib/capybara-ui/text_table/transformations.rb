module Capybara
  module UI
    class TextTable
      module Transformations
        def self.keyword
          ->(val) { val.squeeze(' ').strip.gsub(' ', '_').sub(/\?$/, '').to_sym }
        end

        def self.pass
          ->(val) { val }
        end
      end
    end
  end
end
