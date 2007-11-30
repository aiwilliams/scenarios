extdir = File.dirname(__FILE__) + '/extensions'

require "#{extdir}/string"
require "#{extdir}/symbol"
require "#{extdir}/test_case" rescue nil
require "#{extdir}/active_record"