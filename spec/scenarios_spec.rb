require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe "test/unit support" do
  before do
    @test_result = Test::Unit::TestResult.new
    @test_case = Class.new(Test::Unit::TestCase)
    @test_case.module_eval do
      scenario :things
      def test_something; end
    end
  end
  
  it "should extend TestSuite to allow for scenario unloading after suite has run" do
    suite = @test_case.suite
    suite.should respond_to("run_with_scenarios")
    lambda { suite.run(@test_result) {} }.should_not raise_error
  end
  
  it "should give the test all the helper methods" do
    @test_case.instance_methods.should include("create_record")
  end
  
  it "should work even when RSpec is installed" do pending("A ton of refactoring is going on - they've modified TestCase a lot")
    test = @test_case.new("test_something")
    lambda { test.run(@test_result) {} }.should_not raise_error
    test.things(:one).should_not be_nil
  end
  
  it "should load scenarios on setup and install helpers" do
    test = @test_case.new(Spec::Example::Example.new("ugh, they've changed the signature!") {})
    lambda { test.setup; test.run }.should_not raise_error
    test.things(:one).should_not be_nil
  end
end

describe "Scenario loading" do
  it "should load from configured directories" do
    Scenario.load(:empty)
    EmptyScenario
  end
  
  it "should raise Scenario::NameError when the scenario does not exist" do
    lambda { Scenario.load(:whatcha_talkin_bout) }.should raise_error(Scenario::NameError)
  end
  
  it "should allow us to add helper methods through the helpers class method" do
    klass = :empty.to_scenario
    klass.helpers do
      def hello
        "Hello World"
      end
    end
    klass.new.methods.should include('hello')
  end
end

describe "Scenario example helper methods" do
  scenario :things
  
  it "should understand namespaced models" do
    create_record "ModelModule::Model", :raking, :name => "Raking", :description => "Moving leaves around"
    models(:raking).should_not be_nil
  end
  
  it "should include pluralized record name readers that accept a single record name" do
    things(:one).should be_kind_of(Thing)
    things(:two).name.should == "two"
  end
  
  it "should include pluralized record name readers that accept multiple record names" do
    things(:one, :two).should be_kind_of(Array)
    things(:one, :two).should eql([things(:one), things(:two)])
  end
  
  it "should include singular record id reader that takes a single record name" do
    thing_id(:one).should be_kind_of(Fixnum)
  end
  
  it "should include singular record id reader that takes multiple record names" do
    thing_id(:one, :two).should be_kind_of(Array)
    thing_id(:one, :two).should eql([thing_id(:one), thing_id(:two)])
  end
  
  it "should include record creation methods" do
    create_record(:thing, :three, :name => "Three")
    things(:three).name.should == "Three"
  end
  
  it "should include other example helper methods" do
    create_thing("The Thing")
    things(:the_thing).name.should == "The Thing"
  end
end

describe "it uses people and things scenarios", :shared => true do
  it "should have reader helper methods for each used scenario" do
    should respond_to(:things)
    should respond_to(:people)
  end
  
  it "should allow us to use helper methods from each scenario inside an example" do
    should respond_to(:create_thing)
    should respond_to(:create_person)
  end
end

describe "A composite scenario" do
  scenario :composite
  
  it_should_behave_like "it uses people and things scenarios"
  
  it "should allow us to use helper methods scenario" do
    should respond_to(:method_from_composite_scenario)
  end
end

describe "Multiple scenarios" do
  scenario :things, :people
  
  it_should_behave_like "it uses people and things scenarios"
end

describe "A complex composite scenario" do
  scenario :complex_composite
  
  it_should_behave_like "it uses people and things scenarios"
  
  it "should have correct reader helper methods" do
    should respond_to(:places)
  end
  
  it "should allow us to use correct helper methods" do
    should respond_to(:create_place)
  end
end

describe "Overlapping scenarios" do
  scenario :composite, :things, :people
  
  it "should not cause scenarios to be loaded twice" do
    Person.find_all_by_first_name("John").size.should == 1
  end
end

describe "create_record table method" do
  scenario :empty
  
  it "should automatically set timestamps" do
    create_record :note, :first, :content => "first note"
    note = notes(:first)
    note.created_at.should be_instance_of(Time)
  end
end

describe "create_model table method" do
  scenario :empty
  
  it "should support symbolic names" do
    thing = create_model Thing, :mything, :name => "My Thing", :description => "For testing"
    things(:mything).should == thing
  end
  
  it "should blast any table touched as a side effect of creating a model (callbacks, observers, etc.)" do
    create_model SideEffectyThing
    blasted_tables.should include(Thing.table_name)
  end
end