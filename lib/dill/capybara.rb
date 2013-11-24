Capybara.configure do |config|
  config.match = :one
  config.exact = true
  config.exact_options = true
  config.ignore_hidden_elements = true
  config.visible_text_only = true
end
