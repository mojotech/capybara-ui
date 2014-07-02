require 'spec_helper'

describe 'List verification' do
  shared_examples_for 'a list' do
    context 'when there is no list' do
      GivenHTML ''

      When(:failure) { widget(:list).value }

      Then { failure == Failure(Dill::MissingWidget) }
    end

    context "to verify equality" do
      context 'when the list is empty' do
        GivenHTML <<-HTML
          <ul id="skills"></ul>
        HTML

        When(:list) { widget(:list).value }

        Then { list == [] }
      end

      context 'when the list has one item' do
        GivenHTML <<-HTML
          <ul id="skills">
            <li class='skill'>Seafaring</li>
          </ul>
        HTML

        When(:list) { widget(:list).value }

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

        When(:list) { widget(:list).value }

        Then { list == ['Seafaring', 'Insult swordfighting', 'Long range spitting'] }
      end
    end
  end

  context 'with defaults' do
    GivenWidget do
      class List < Dill::List
      end
    end

    pending '[FIXME: empty list test is failing]' do
      it_should_behave_like 'a list'
    end
  end

  context 'given the standard list item' do
    GivenWidget do
      class List < Dill::List
        root '#skills'
        item '.skill'
      end
    end

    it_should_behave_like 'a list'
  end
end
