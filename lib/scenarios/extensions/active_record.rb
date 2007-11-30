module ActiveRecord
  module ConnectionAdapters
    class AbstractAdapter
      cattr_accessor :table_config
      
      include Scenarios::TableBlasting
      
      # In order to guarantee that tables are tracked when _create_model_ is
      # used, and those models have side effects, we need to get near the
      # metal, and that in a spot that won't have us messing with every
      # adapter known to man. That is, we can't listen at _execute_, since
      # that is a concrete method, specially implemented in the various
      # adapters.
      def insert_sql_with_table_blasting(sql, *args) # :nodoc:
        table_name = $1 if sql =~ /^insert into `?(\w+)/i
        blast_table(table_name) unless table_name.nil? || blasted_tables.include?(table_name)
        insert_sql_without_table_blasting(sql, *args)
      end
      alias_method_chain :insert_sql, :table_blasting
    end
  end
end