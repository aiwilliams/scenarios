require File.dirname(__FILE__) + '/scenarios/extensions'

require 'set'
require 'active_record/fixtures'

module Scenarios
  class InvalidScenario < StandardError; end
  
  def self.load(scenario_name)
    klass = scenario_name.to_scenario
    klass.load
    klass
  rescue NameError
    raise InvalidScenario
  end

  module TableMethods
    attr_accessor :table_config
    delegate :table_readers, :blasted_tables, :modified_tables, :symbolic_names_to_id, :to => :table_config

    def blast_table(name)
      ActiveRecord::Base.silence do
        ActiveRecord::Base.connection.delete "DELETE FROM #{name}", "Scenario Delete"
      end
      blasted_tables << name
    end

    # Inserts a record into the database.
    #
    #   create_record :event, :one, :name => "Showdown"
    #   create_record :event, :name => "Showdown"
    #
    # The first form will assign the returned record id to the provided _symbolic_name_,
    # so that in your tests you may invoke something like this:
    #
    #   events(:one)
    #
    # The second form will not remember the record id, so the events method will not
    # be able to answer that record.
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

  module Loaders
    def load_all(scenario_classes)
      self.table_config = Config.new
      @loaded_scenarios = []
      previous_scenario = nil
      scenario_classes.each do |scenario_class|
        scenario = scenario_class.new(table_config)
        if previous_scenario
          scenario_class.test_helpers.extend previous_scenario.class.test_helpers
          scenario_class.send :include, previous_scenario.class.test_helpers
          scenario.table_readers.extend previous_scenario.table_readers
        end
        scenario.load
        self.class.send :include, scenario_class.test_helpers
        self.class.send :include, scenario.table_readers
        previous_scenario = scenario
        @loaded_scenarios << scenario
      end
    end
  end

  class Base
    class << self
      def load
        new.load_all(used_scenarios + [self])
      end
  
      def used_scenarios
        @used_scenarios ||= []
        @used_scenarios = (@used_scenarios.collect(&:used_scenarios) + @used_scenarios).flatten.uniq
      end
  
      def uses(*names)
        names = names.map(&:to_scenario).reject { |n| used_scenarios.include?(n) }
        used_scenarios.concat(names)
      end
  
      def test_helpers
        const_get(:TestHelpers) rescue const_set(:TestHelpers, Module.new)
      end
  
      def to_scenario
        self
      end
    end

    include TableMethods
    include Loaders

    def initialize(config = Config.new)
      self.table_config = config
      self.extend table_config.table_readers
      self.extend self.class.test_helpers
    end

    def load
      # implement in subclass
    end

    def unload
      modified_tables.each {|name| blast_table name}
    end
  end

  class Config
    attr_reader :blasted_tables, :modified_tables, :table_readers, :symbolic_names_to_id
    def initialize
      @blasted_tables       = Set.new,
      @modified_tables      = Set.new,
      @table_readers        = Module.new,
      @symbolic_names_to_id = Hash.new {|h,k| h[k] = Hash.new}
    end
  end
  
end