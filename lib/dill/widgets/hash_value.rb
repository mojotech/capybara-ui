module Dill
  class HashValue < Hash
    def initialize(hash)
      @hash = hash
    end

    def downcase_all
      @hash.each do |k, v|
        case v
        when String
          @hash[k] = v.downcase
        when Hash
          self.class.new(v).downcase_all
        when Array
          ArrayValue.new(v).downcase_all
        end
      end
    end
  end
end
