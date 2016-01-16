require 'spec_helper'

DRIVERS.each do |driver|
  describe "CapybaraUI::Document #{driver}", driver: driver do
    describe '.body' do
      GivenHTML <<-HTML
        <p>CapybaraUI</p>
      HTML

      When(:body) {
        "<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\" \"http://www.w3.org/TR/REC-html40/loose.dtd\">\n" \
        "<html xmlns=\"http://www.w3.org/1999/xhtml\">" \
        "<head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />" \
        "<body><p>CapybaraUI</p></body></head>\n</html>\n"
      }

      Then { document.body == body }
    end
  end
end