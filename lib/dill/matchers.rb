RSpec::Matchers.define :see do |widget_name|
  match  do |role|
    role.see?(widget_name)
  end
end
