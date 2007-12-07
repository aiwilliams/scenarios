require File.expand_path(File.dirname(__FILE__) + "/../testing/environment")
TESTING_ENVIRONMENTS[TESTING_ENVIRONMENT || "RSpec/Rails Trunk"].load(DATABASE_ADAPTER || "mysql")
require "models"
require "test/unit"
require "scenarios"
