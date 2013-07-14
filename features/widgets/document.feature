Feature: Document

  The `document` is exposed by default to cucumber steps. You can use it as a
  more readable way to test if certain top level widgets exist on a page. For
  example, using rspec you're able to write the following:

      expect(document).to have_widget(<widget>)

  Scenario: Check whether a widget exists in the document
    Given the page /profile includes the following HTML:
      """
      <div>
        <span id="name">Guybrush Threepwood</span>
      </div>
      """
    Given the following widget:
      """
      class Name < Widget
        root 'span'
      end
      """
    Then "document.has_widget?(:name)" should return "true"
