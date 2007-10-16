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
    lambda do
      Scenario.load(:simplest)
      SimplestScenario
    end.should_not raise_error
  end
  
  it "should allow us to add helper methods through the helpers class method" do
    klass = scenario_class(:simplest)
    klass.helpers do
      def hello
        "Hello World"
      end
    end
    klass.helpers.methods.should include('hello')
  end
  
  def scenario_class(name)
    name.to_scenario
  end
end

describe "Rspec description scenario class method" do
  scenario :thing

  it "should allow us to use record creation methods from with an example" do
    lambda do
      create_record(:thing, :name => "The Thing")
    end.should_not raise_error
  end

  xit "should allow us to use helper methods from with an example" do
    lambda do
      create_thing(:name => "The Thing")
    end.should_not raise_error
  end
end