module Scenarios
  module Loading # :nodoc:
    
    def self.included(base)
      base.module_eval do
        superclass_delegating_accessor :loaded_scenarios
      end
    end
    
    def load_scenarios(scenario_classes)
      self.table_config = Configuration.new
      self.class.loaded_scenarios = []
      previous_scenario = nil
      if scenario_classes
        scenario_classes.each do |scenario_class|
          scenario = scenario_class.new(table_config)
          if previous_scenario
            scenario_class.helpers.extend previous_scenario.class.helpers
            scenario_class.send :include, previous_scenario.class.helpers
            scenario.table_readers.extend previous_scenario.table_readers
          end
          scenario.load
          self.class.send :include, scenario_class.helpers
          self.class.send :include, scenario.table_readers
          previous_scenario = scenario
          loaded_scenarios << scenario
        end
      end
    end
    
  end
end