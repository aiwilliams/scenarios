module Scenarios
  # Provides scenario loading and convenience methods around the DataSession
  # that must be made available through a method _data_session_.
  module Loading # :nodoc:
    def load_scenarios(scenario_classes)
      scenario_classes.each do |scenario_class|
        scenario = scenario_class.new(data_session)
        scenario.load
        data_session.loaded_scenarios << scenario
      end if scenario_classes
    end
    
    def loaded_scenarios
      data_session.loaded_scenarios
    end
    
    def scenarios_loaded?
      data_session && data_session.scenarios_loaded?
    end
    
    # The sum of all the loaded scenario's helper methods. These can be mixed
    # into anything you like to gain access to them.
    def scenario_helpers
      data_session.scenario_helpers
    end
    
    # The sum of all the available table reading methods. These will only
    # include readers for which data has been placed into the table. These can
    # be mixed into anything you like to gain access to them.
    def table_readers
      data_session.table_readers
    end
  end
end