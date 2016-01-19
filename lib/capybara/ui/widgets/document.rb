module Capybara
  module UI
    class Document
      include WidgetParts::Container

      def initialize(widget_lookup_scope)
        self.widget_lookup_scope = widget_lookup_scope or raise 'No scope given'
      end

      def root
        Capybara.current_session
      end

      def body
        xml = Nokogiri::HTML(Capybara.page.body).to_xml

        Nokogiri::XML(xml, &:noblanks).to_xhtml
      end
    end
  end
end
