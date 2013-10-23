require 'spec_helper'

describe 'List verification' do
  shared_examples_for 'a list' do
    context 'when there is no list' do
      GivenHTML ''

      When(:failure) { w.value }

      Then { failure == Failure(Capybara::ElementNotFound) }
    end

    context 'to verify equality' do
      context 'when the list is empty' do
        GivenHTML <<-HTML
          <ul id="skills"></ul>
        HTML

        When(:list) { w.value }

        Then { list == [] }
      end

      context 'when the list has one item' do
        GivenHTML <<-HTML
          <ul id="skills">
            <li class='skill'>Seafaring</li>
          </ul>
        HTML

        When(:list) { w.value }

        Then { list == ['Seafaring'] }
      end

      context 'when the list has many items' do
        GivenHTML <<-HTML
          <ul id="skills">
            <li class='skill'>Seafaring</li>
            <li class='skill'>Insult swordfighting</li>
            <li class='skill'>Long range spitting</li>
          </ul>
        HTML

        When(:list) { w.value }

        Then { list == ['Seafaring', 'Insult swordfighting', 'Long range spitting'] }
      end
    end
  end

  context 'with defaults' do
    GivenWidget Dill::List

    pending '[FIXME: empty list test is failing]' do
      it_should_behave_like 'a list'
    end
  end

  context 'given the standard list item' do
    GivenWidget Dill::List do
      root '#skills'
      item '.skill'
    end

    it_should_behave_like 'a list'
  end
end
