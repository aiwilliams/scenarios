unless defined?(PLUGIN_ROOT)
  PLUGIN_ROOT         = File.expand_path(File.dirname(__FILE__) + "/..")
  RAILS_ROOT          = PLUGIN_ROOT
  APP_ROOT            = "#{PLUGIN_ROOT}/app"
  SUPPORT_TEMP        = "#{PLUGIN_ROOT}/tmp"
  SUPPORT_LIB         = "#{SUPPORT_TEMP}/lib"
  ACTIONPACK_ROOT     = "#{SUPPORT_LIB}/actionpack"
  ACTIVESUPPORT_ROOT  = "#{SUPPORT_LIB}/activesupport"
  ACTIVERECORD_ROOT   = "#{SUPPORT_LIB}/activerecord"
  SPEC_ROOT           = "#{PLUGIN_ROOT}/spec"
  RSPEC_ROOT          = "#{SUPPORT_LIB}/rspec"
  RSPEC_ON_RAILS_ROOT = "#{SUPPORT_LIB}/rspec_on_rails"
  TEST_ROOT           = "#{PLUGIN_ROOT}/test"
  DB_CONFIG_FILE      = "#{APP_ROOT}/database.yml"
  DB_SCHEMA_FILE      = "#{APP_ROOT}/schema.rb"
  
  $: << "#{APP_ROOT}"
  $: << "#{PLUGIN_ROOT}/lib"
  $: << "#{ACTIONPACK_ROOT}/lib"
  $: << "#{ACTIVERECORD_ROOT}/lib"
  $: << "#{ACTIVESUPPORT_ROOT}/lib"
  
  require 'active_support'
  require 'active_record'
  require 'action_controller'
  require 'action_view'
  
  require 'logger'
  RAILS_DEFAULT_LOGGER = Logger.new("#{SUPPORT_TEMP}/test.log")
  RAILS_DEFAULT_LOGGER.level = Logger::DEBUG
  ActiveRecord::Base.logger = RAILS_DEFAULT_LOGGER
end