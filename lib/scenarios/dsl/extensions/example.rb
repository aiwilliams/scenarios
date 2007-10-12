module Scenarios
  module DSL
    
    module ExampleExtensions
      include ::Scenarios::TableMethods
      include ::Scenarios::Loaders
    end
    
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
  include Scenarios::DSL::ExampleExtensions
end