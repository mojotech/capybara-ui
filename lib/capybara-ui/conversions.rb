module CapybaraUI
  module Conversions
    extend self

    def Boolean(val)
      case val
      when 'yes', 'true', true
        true
      when 'no', 'false', false, nil, ''
        false
      else
        raise ArgumentError, "can't convert #{val.inspect} to boolean"
      end
    end

    def List(valstr, &block)
      vs = valstr.strip.split(/\s*,\s*/)

      block ? vs.map(&block) : vs
    end

    def Timeish(val)
      raise ArgumentError, "can't convert nil to Timeish" if val.nil?

      return val if Date === val || Time === val || DateTime === val

      Chronic.parse(val) or
        raise ArgumentError, "can't parse #{val.inspect} to Timeish"
    end
  end
end
