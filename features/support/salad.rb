dir         = File.dirname(__FILE__)
project_dir = File.join(dir, %w(.. ..))
lib_dir     = File.join(project_dir, 'lib')

$:.unshift File.expand_path lib_dir

require 'dill/cucumber'

class Widget < Dill::Widget
  def self.selector
    @selector || 'div'
  end
end
