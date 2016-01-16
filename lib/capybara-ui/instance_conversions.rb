module CapybaraUI
  module InstanceConversions
    def self.included(base)
      base.send :include, CapybaraUI::Conversions
    end

    def to_boolean
      Boolean(self)
    end

    def to_a
      List(self)
    end

    def to_time
      Timeish(self)
    end
  end
end
