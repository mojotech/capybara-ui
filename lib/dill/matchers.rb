RSpec::Matchers.define :see do |widget_name, *args|
  match  do |role|
    role.see?(widget_name, *args)
  end
end
