dir         = File.dirname(__FILE__)
project_dir = File.join(dir, %w(.. ..))
lib_dir     = File.join(project_dir, 'lib')

$:.unshift File.expand_path lib_dir

require 'cucumber/salad'

class Widget
  def self.selector
    @selector || 'div'
  end
end
