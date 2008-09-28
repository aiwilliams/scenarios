module Test #:nodoc:
  module Unit #:nodoc:
    class TestCase #:nodoc:
      superclass_delegating_accessor :scenario_classes
      superclass_delegating_accessor :data_session
      
      # Changing either of these is not supported at this time.
      self.use_transactional_fixtures = true
      self.use_instantiated_fixtures = false
      
      include Scenarios::TableMethods
      include Scenarios::Loading
      
      class << self
        # This class method is mixed into RSpec and allows you to declare that
        # you are using a given scenario or set of scenarios within a spec:
        #
        #   scenario :basic  # loads BasicScenario and any dependencies
        #   scenario :posts, :comments  # loads PostsScenario and CommentsScenario
        #
        # It accepts an array of scenarios (strings, symbols, or classes) and
        # will load them roughly in the order that they are specified.
        def scenario(*names)
          self.scenario_classes = []
          names.each do |name|
            scenario_class = name.to_scenario
            scenario_classes.concat(scenario_class.used_scenarios + [scenario_class])
          end
          scenario_classes.uniq!
        end
      end
      
      # Hook into fixtures loading lifecycle to instead load scenarios. This
      # is expected to be called in a fashion respective of
      # use_transactional_fixtures. I feel like a leech.
      def load_fixtures
        if !scenarios_loaded? || !use_transactional_fixtures?
          if !use_transactional_fixtures? || data_session.nil?
            self.class.data_session = Scenarios::DataSession.new
            self.class.data_session.clear_tables
          end
          load_scenarios(scenario_classes)
        end
        self.extend scenario_helpers
        self.extend table_readers
      end
    end
  end
end