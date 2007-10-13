require File.dirname(__FILE__) + "/spec_helper"

describe "Scenario database", :shared => true do
  before :all do
    @table_config = Scenarios::Config.new
    @connection = ActiveRecord::Base.connection
    @connection.create_table :things, :force => true do |t|
      t.string :name
    end
    
    class ::Thing < ActiveRecord::Base; end unless defined?(Thing)
  end
  
  before :each do
    self.extend Scenarios::TableMethods
  end
  
  it "should be able to create a record" do
    create_record :thing, :name => "bobby"
  end
end

describe "Scenarios on MySQL" do
  before(:all) do
    system "mysqladmin -uroot drop #{ActiveRecord::Base.configurations['mysql'][:database]} --force"
    system "mysqladmin -uroot create #{ActiveRecord::Base.configurations['mysql'][:database]}"
    ActiveRecord::Base.establish_connection 'mysql'
  end
  it_should_behave_like "Scenario database"
end

describe "Scenarios on Sqlite3" do
  before(:all) do
    File.delete(ActiveRecord::Base.configurations['sqlite3'][:database])
    ActiveRecord::Base.establish_connection 'sqlite3'
  end
  it_should_behave_like "Scenario database"
end