require File.dirname(__FILE__) + "/spec_helper"

class ::Thing < ActiveRecord::Base; end

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
    klass = scenario_class(:simplest)
    klass.helpers do
      def hello
        "Hello World"
      end
    end
    klass.new.methods.should include('hello')
  end
  
  def scenario_class(name)
    name.to_scenario
  end
end

describe "Single Scenario" do
  scenario :thing
  
  it "should allow us access to records through record_name helper method" do
    things(:one).should be_kind_of Thing
    things(:two).name.should == "two"
  end
  
  it "should allow us to use record creation methods from with an example" do
    create_record(:thing, :three, :name => "Three")
    things(:three).name.should == "Three"
  end
  
  it "should allow us to use helper methods from inside an example" do
    create_thing(:name => "The Thing")
    things(:the_thing).name.should == "The Thing"
  end
end

describe "Composite Scenario" do
  #scenario :composite
  
  it "should test composite"
  
end