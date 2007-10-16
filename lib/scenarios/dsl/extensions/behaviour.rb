module Scenarios
  module DSL
    module ClassMethods
      def scenario(*names)
        if @scenario_classes.nil?
          @scenario_classes = []
          all_scenario_classes = @scenario_classes
          
          before(:all) do
            load_scenarios(all_scenario_classes)
          end
          
          before(:each) do
            ActiveRecord::Base.send :increment_open_transactions
            ActiveRecord::Base.connection.begin_db_transaction
          end
          
          after(:each) do
            if Thread.current['open_transactions'] != 0
              ActiveRecord::Base.connection.rollback_db_transaction
              Thread.current['open_transactions'] = 0
            end
            ActiveRecord::Base.verify_active_connections!
          end
          
          after(:all) do
            @loaded_scenarios.each {|s| s.unload}
          end
        end
        names.each do |name|
          scenario_class = name.to_scenario
          @scenario_classes.concat(scenario_class.used_scenarios + [scenario_class])
        end
        @scenario_classes.uniq!
      end
    end
  end
end