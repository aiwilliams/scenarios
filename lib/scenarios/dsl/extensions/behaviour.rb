module Scenarios
  module DSL
    
    module ClassMethods
      def scenario(name)
        scenario_class = name.to_scenario
        scenario = scenario_class.new(Scenario::Config.new)
                          
        before(:all) do
          scenario.load
          @table_config = scenario.table_config
        end
        
        before(:each) do
          ActiveRecord::Base.send :increment_open_transactions
          ActiveRecord::Base.connection.begin_db_transaction
          self.extend scenario.table_readers
          self.extend scenario.class.helpers
        end
        
        after(:each) do
          if Thread.current['open_transactions'] != 0
            ActiveRecord::Base.connection.rollback_db_transaction
            Thread.current['open_transactions'] = 0
          end
          ActiveRecord::Base.verify_active_connections!
        end
        
        after(:all) do
          scenario.unload
        end
      end
    end
    
  end
end