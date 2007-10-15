require File.dirname(__FILE__) + "/spec_helper"

describe "Scenario database", :shared => true do
  before :all do
    @table_config = Scenarios::Config.new
    @connection = ActiveRecord::Base.connection
    @connection.create_table :things, :force => true do |t|
      t.string :name
      t.string :description
    end
    
    class ::Thing < ActiveRecord::Base; end unless defined?(Thing)
  end
  
  before :each do
    self.extend Scenarios::TableMethods
  end
  
  it "should be able to create a record" do
    create_record :thing, :name => "bobby", :description => "a little boy"
    Thing.find_by_name("bobby").description.should == "a little boy"
  end
end

describe "Scenarios on MySQL" do
  before(:all) do
    `mysqladmin -uroot drop #{ActiveRecord::Base.configurations['mysql'][:database]} --force`
    `mysqladmin -uroot create #{ActiveRecord::Base.configurations['mysql'][:database]}`
    ActiveRecord::Base.establish_connection 'mysql'
  end
  it_should_behave_like "Scenario database"
end

describe "Sqlite3 database", :shared => true do
  before(:all) do
    database = ActiveRecord::Base.configurations['sqlite3'][:database]
    File.delete(database) if File.exists?(database)
    ActiveRecord::Base.establish_connection 'sqlite3'
  end
end

describe "Scenarios on Sqlite3" do
  it_should_behave_like "Sqlite3 database"
  it_should_behave_like "Scenario database"
end

describe Scenario do
  it_should_behave_like "Sqlite3 database"

  before :all do
    Scenario.load_paths = ["#{PLUGIN_ROOT}/spec/fixtures/scenarios/independant"]
  end
  
  it "should load from configured directories" do
    Scenario.load(:simplest)
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