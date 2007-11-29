require File.expand_path(File.dirname(__FILE__) + "/../app/environment")

unless defined? DATABASE_ADAPTER
  DATABASE_ADAPTER = ENV["DB"] || "sqlite3"
  ActiveRecord::Base.configurations = YAML.load(IO.read(DB_CONFIG_FILE))
  ActiveRecord::Base.establish_connection DATABASE_ADAPTER
  require "models"
  
  require "test/unit"
  require "scenarios"
end