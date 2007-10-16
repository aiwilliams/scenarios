require File.dirname(__FILE__) + "/extensions/behaviour"
require File.dirname(__FILE__) + "/extensions/example"

Spec::DSL::Example.module_eval do
  def self.inherited(klass)
    super
    klass.extend Scenarios::DSL::ClassMethods
    klass.send :include, Scenarios::DSL::ExampleExtensions
  end
end