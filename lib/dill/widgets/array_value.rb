module Dill
  class ArrayValue < Array
    def downcase_all
      result = self.map do |item|
        case item
        when String
          item.downcase
        when Array
          self.class.new(item).downcase_all
        when Hash
          HashValue.new(item).downcase_all
        end
      end

      ArrayValue.new(result)
    end
  end
end
