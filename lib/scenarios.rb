require File.dirname(__FILE__) + '/scenarios/extensions'
require 'active_record/fixtures'

# :include:README
module Scenario
  # Thrown by Scenario.load when it cannot find a specific senario.
  class InvalidScenario < StandardError; end
  
  class << self
    mattr_accessor :load_paths
    self.load_paths = ["#{RAILS_ROOT}/spec/scenarios", "#{RAILS_ROOT}/test/scenarios"]
    
    # Load a scenario by name. <tt>scenario_name</tt> can be a string, symbol,
    # or the scenario class.
    def load(scenario_name)
      klass = scenario_name.to_scenario
      klass.load
      klass
    rescue NameError => e
      raise InvalidScenario, e.message
    end
  end
  
  module TableMethods
    attr_accessor :table_config
    delegate :table_readers, :blasted_tables, :modified_tables, :symbolic_names_to_id, :to => :table_config
    
    # Inserts a record into the database. And adds the appropriate table
    # reader helpers into the scenario and spec.
    #
    #   create_record :event, :one, :name => "Showdown"
    #   create_record :event, :name => "Showdown"
    #
    # The first form will assign the returned record id to the provided
    # _symbolic_name_, so that in your tests you may invoke something like
    # this:
    #
    #   events(:one)
    #
    # The second form will not remember the record id, so the events method
    # will not be able to answer that record.
    def create_record(class_name, *args)
      symbolic_name, attributes = extract_creation_arguments(args)
      table_name = class_name.to_s.pluralize
      record_id = nil
      fixture = Fixture.new(attributes, class_name)
      ActiveRecord::Base.silence do
        blast_table(table_name) unless blasted_tables.include?(table_name)
        ActiveRecord::Base.connection.insert_fixture(fixture, table_name)
        record_id = ActiveRecord::Base.connection.select_value("SELECT id FROM #{table_name} order by id desc limit 1").to_i
        symbolic_names_to_id[table_name][symbolic_name] = record_id if symbolic_name
        update_table_readers(symbolic_names_to_id, class_name, table_name)
        modified_tables << table_name
      end
      record_id
    end
    
    def blast_table(name) # :nodoc:
      ActiveRecord::Base.silence do
        ActiveRecord::Base.connection.delete "DELETE FROM #{name}", "Scenario Delete"
      end
      blasted_tables << name
    end
    
    private
      
      def extract_creation_arguments(arguments)
        if arguments.size == 2 && arguments.last.kind_of?(Hash)
          arguments
        elsif arguments.size == 1 && arguments.last.kind_of?(Hash)
          [nil, arguments[0]]
        else
          [nil, Hash.new]
        end
      end
      
      def update_table_readers(ids, class_name, table_name)
        record_type = class_name.to_s.classify.constantize
        record_id_method = "#{class_name.to_s.underscore}_id".to_sym
        table_readers.send :define_method, record_id_method do |symbolic_name|
          record_id = ids[table_name][symbolic_name]
          raise ActiveRecord::RecordNotFound, "No object is associated with #{table_name}(:#{symbolic_name})" unless record_id
          record_id
        end
        table_readers.send :define_method, table_name do |symbolic_name|
          record_type.find(send(record_id_method, symbolic_name))
        end
        metaclass.send :include, table_readers
      end
      
      def metaclass
        (class << self; self; end)
      end
  end

  module Loaders # :nodoc:
    def load_scenarios(scenario_classes)
      self.table_config = Config.new
      @loaded_scenarios = []
      previous_scenario = nil
      scenario_classes.each do |scenario_class|
        scenario = scenario_class.new(table_config)
        if previous_scenario
          scenario_class.helpers.extend previous_scenario.class.helpers
          scenario_class.send :include, previous_scenario.class.helpers
          scenario.table_readers.extend previous_scenario.table_readers
        end
        scenario.load
        self.class.send :include, scenario_class.helpers
        self.class.send :include, scenario.table_readers
        previous_scenario = scenario
        @loaded_scenarios << scenario
      end
    end
  end

  class Base
    class << self
      # Class method to load the scenario. Used internally by the Scenarios
      # plugin.
      def load
        new.load_scenarios(used_scenarios + [self])
      end
      
      # Class method for your own scenario to define helper methods that will
      # be included into the scenario and all specs that include the scenario
      def helpers(&block)
        mod = (const_get(:Helpers) rescue const_set(:Helpers, Module.new))
        mod.module_eval(&block) if block_given?
        mod
      end
      
      # Class method for your own scenario to define the scenarios that it
      # depends on. If your scenario depends on other scenarios those
      # scenarios will be loaded before the load method on your scenario is
      # executed.
      def uses(*scenarios)
        names = scenarios.map(&:to_scenario).reject { |n| used_scenarios.include?(n) }
        used_scenarios.concat(names)
      end
      
      # Class method that returns the scenarios used by your scenario.
      def used_scenarios # :nodoc:
        @used_scenarios ||= []
        @used_scenarios = (@used_scenarios.collect(&:used_scenarios) + @used_scenarios).flatten.uniq
      end
      
      # Returns the scenario class.
      def to_scenario
        self
      end
    end
    
    include TableMethods
    include Loaders
    
    # Initialize a scenario with a configuration. Used internally by the
    # Scenarios plugin.
    def initialize(config = Config.new)
      self.table_config = config
      self.extend table_config.table_readers
      self.extend self.class.helpers
    end
    
    # This method should be implemented in your own scenarios.
    def load
    end
    
    # Blasts all tables used by a scenario in its load method.
    def unload
      modified_tables.each { |name| blast_table(name) }
    end
  end

  class Config # :nodoc:
    attr_reader :blasted_tables, :modified_tables, :table_readers, :symbolic_names_to_id
    def initialize
      @blasted_tables       = Set.new,
      @modified_tables      = Set.new,
      @table_readers        = Module.new,
      @symbolic_names_to_id = Hash.new {|h,k| h[k] = Hash.new}
    end
  end
  
end

Scenarios = Scenario