module Scenarios
  class Configuration # :nodoc:
    attr_reader :blasted_tables, :record_metas, :table_readers, :symbolic_names_to_id
    
    def initialize
      @blasted_tables       = Set.new,
      @record_metas         = Hash.new,
      @table_readers        = Module.new,
      @symbolic_names_to_id = Hash.new {|h,k| h[k] = Hash.new}
    end
  end
end