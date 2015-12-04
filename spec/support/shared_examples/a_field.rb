shared_examples 'a field' do
  context 'when using an auto locator' do
    Then { widget(:field_group).visible?(:auto_locator) }
  end
end
