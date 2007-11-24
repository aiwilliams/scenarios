module Test #:nodoc:
  module Unit #:nodoc:
    class TestCase #:nodoc:
      superclass_delegating_accessor :scenario_classes
      
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
      
        # Overridden to provide before all and after all code which sets up and
        # tears down scenarios
        def suite_with_scenarios
          suite = suite_without_scenarios
          class << suite
            attr_accessor :test_class
            def run_with_scenarios(*args)
              run_without_scenarios(*args)
              test_class.loaded_scenarios.each { |s| s.unload } if test_class.loaded_scenarios && test_class.use_transactional_fixtures
            end
            alias_method_chain :run, :scenarios
          end
          suite.test_class = self
          suite
        end
        alias_method_chain :suite, :scenarios
      end
      
      # Hook into fixtures loading lifecycle to instead load scenarios. This
      # is expected to be called in a fashion respective of
      # use_transactional_fixtures. I feel like a leech.
      def load_fixtures
        load_scenarios(scenario_classes)
      end
      
      # Here we are counting on existing logic to allow teardown method
      # overriding as done in fixtures.rb. Only if transaction fixtures are
      # not being used do we unload scenarios after a test. Otherwise, we wait
      # until the end of the run of all tests on this test_case (collection of
      # tests, right!). See the TestSuite extension done in _suite_ for
      # behaviour when using transaction fixtures.
      def teardown_with_scenarios
        loaded_scenarios.each { |s| s.unload } unless use_transactional_fixtures?
      end
      alias_method_chain :teardown, :scenarios
      
    end
  end
end