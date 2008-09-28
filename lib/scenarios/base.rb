module Scenarios
  class Base
    class << self
      # Class method to load the scenario. Used internally by the Scenarios
      # plugin.
      def load
        scenario = new
        scenario.data_session.clear_tables
        scenario.load_scenarios(used_scenarios + [self])
      end
      
      # Class method for your own scenario to define helper methods that will
      # be included into the scenario and all specs that include the scenario
      def helpers(&block)
        mod = (const_get(:Helpers) rescue const_set(:Helpers, Module.new))
        mod.module_eval(&block) if block_given?
        mod
      end
      
      # Class method for your own scenario to define the scenarios that it
      # depends on. If your scenario depends on other scenarios those
      # scenarios will be loaded before the load method on your scenario is
      # executed.
      def uses(*scenarios)
        names = scenarios.map(&:to_scenario).reject { |n| used_scenarios.include?(n) }
        used_scenarios.concat(names)
      end
      
      # Class method that returns the scenarios used by your scenario.
      def used_scenarios # :nodoc:
        @used_scenarios ||= []
        @used_scenarios = (@used_scenarios.collect(&:used_scenarios) + @used_scenarios).flatten.uniq
      end
      
      # Returns the scenario class.
      def to_scenario
        self
      end
    end
    
    include TableMethods
    include Loading
    
    attr_reader :data_session
    
    # Initialize a scenario with a DataSession. Used internally by the
    # Scenarios plugin.
    def initialize(session = DataSession.new)
      @data_session = session
      data_session.update_scenario_helpers self.class
      self.extend data_session.table_readers
      self.extend data_session.scenario_helpers
    end
    
    # This method should be implemented in your scenarios. You may also have
    # scenarios that simply use other scenarios, so it is not required that
    # this be overridden.
    def load
    end
  end
end