require File.dirname(__FILE__) + "/../support/environment"

$: << "#{PLUGIN_ROOT}/lib"
$: << "#{RSPEC_ROOT}/lib"
$: << "#{ACTIVERECORD_ROOT}/lib"
$: << "#{ACTIVESUPPORT_ROOT}/lib"
$: << "#{RSPEC_ON_RAILS_ROOT}/lib"

require 'spec'
require 'activesupport'
require 'activerecord'
require 'scenarios'