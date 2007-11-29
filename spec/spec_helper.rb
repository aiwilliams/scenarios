require File.expand_path(File.dirname(__FILE__) + "/../app/environment")

unless defined? DATABASE_ADAPTER
  $: << "#{RSPEC_ROOT}/lib"
  $: << "#{RSPEC_ON_RAILS_ROOT}/lib"
  
  DATABASE_ADAPTER = ENV["DB"] || "sqlite3"
  ActiveRecord::Base.configurations = YAML.load(IO.read(DB_CONFIG_FILE))
  ActiveRecord::Base.establish_connection DATABASE_ADAPTER
  require "models"
  
  require "spec"
  require "spec/rails"
  require "scenarios"
end