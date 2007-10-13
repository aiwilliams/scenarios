require File.dirname(__FILE__) + "/../spec/environment"

$: << "#{PLUGIN_ROOT}/lib"
$: << "#{RSPEC_ROOT}/lib"
$: << "#{ACTIVERECORD_ROOT}/lib"
$: << "#{ACTIVESUPPORT_ROOT}/lib"
$: << "#{RSPEC_ON_RAILS_ROOT}/lib"

require 'spec'
require 'activesupport'
require 'activerecord'
require 'scenarios'

require 'logger'
RAILS_DEFAULT_LOGGER = Logger.new("#{SUPPORT_TEMP}/spec.log")
RAILS_DEFAULT_LOGGER.level = Logger::DEBUG
ActiveRecord::Base.logger = RAILS_DEFAULT_LOGGER

ActiveRecord::Base.configurations = {
  'mysql' => {
    :adapter  => 'mysql',
    :username => 'root',
    :database => 'scenarios_spec',
  },
  'sqlite3' => {
    :adapter => 'sqlite3',
    :database => "#{SUPPORT_TEMP}/sqlite3.db",
    :timeout => 5000
  }
}