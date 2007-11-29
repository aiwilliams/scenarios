require File.dirname(__FILE__) + "/test_helper"

raise "RSpec should not have been loaded" if defined?(Spec)

class ScenariosTest < Test::Unit::TestCase
  def setup
    @test_result = Test::Unit::TestResult.new
    @test_case = Class.new(Test::Unit::TestCase)
    @test_case.module_eval do
      scenario :things
      def test_something; end
    end
  end
  
  def test_should_extend_TestSuite_to_allow_for_scenario_unloading_after_suite_has_run
    suite = @test_case.suite
    assert suite.respond_to?("run_with_scenarios")
    assert_nothing_raised { suite.run(@test_result) {} }
  end
  
  def test_should_give_the_test_all_the_helper_methods
    assert @test_case.instance_methods.include?("create_record")
  end
  
  def test_should_load_scenarios_on_setup_and_install_helpers
    test = @test_case.new("test_something")
    assert_nothing_raised { test.run(@test_result) {|state,name|} }
    assert !test.things(:one).nil?
  end
end