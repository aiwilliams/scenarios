require File.dirname(__FILE__) + "/spec_helper"

describe "Scenario database", :shared => true do
  it "should be able to create a record" do
    @table_config = Scenarios::Config.new
    self.extend Scenarios::TableMethods
    create_record :thing, :name => "bobby", :description => "a little boy"
    Thing.find_by_name("bobby").description.should == "a little boy"
  end
end

describe Scenario do
  it "should load from configured directories" do
    Scenario.load(:simplest)
    SimplestScenario
  end
  
  it "should allow us to add helper methods through the helpers class method" do
    klass = :simplest.to_scenario
    klass.helpers do
      def hello
        "Hello World"
      end
    end
    klass.new.methods.should include('hello')
  end
  
  it "should have a different name for the load_all method"
end

describe "Rspec description" do
  scenario :things
  
  it "should allow us access to records through reader helper methods" do
    things(:one).should be_kind_of(Thing)
    things(:two).name.should == "two"
  end
  
  it "should allow us to use record creation methods from with an example" do
    create_record(:thing, :three, :name => "Three")
    things(:three).name.should == "Three"
  end
  
  it "should allow us to use helper methods from inside an example" do
    create_thing("The Thing")
    things(:the_thing).name.should == "The Thing"
  end
end

describe "Composite Scenario" do
  scenario :composite
  
  it "should have reader helper methods for each used scenario" do
    should respond_to(:things)
    should respond_to(:people)
  end
  
  it "should allow us to use helper methods from each scenario inside an example" do
    should respond_to(:create_thing)
    should respond_to(:create_person)
  end
end