require File.dirname(__FILE__) + "/extensions/behaviour"
require File.dirname(__FILE__) + "/extensions/example"

Spec::DSL::Example.module_eval do
  def self.inherited(klass) # :nodoc:
    super
    klass.extend Scenarios::DSL::ClassMethods
  end
end

# Some may may include this
Spec::DSL::ExampleModule.module_eval do
  include Scenarios::DSL::ExampleExtensions
end

# And some may extend this
Spec::DSL::Example.module_eval do
  include Scenarios::DSL::ExampleExtensions
end

# While others work under here
Test::Unit::TestCase.module_eval do
  extend Scenarios::DSL::ClassMethods
  include Scenarios::DSL::ExampleExtensions
end