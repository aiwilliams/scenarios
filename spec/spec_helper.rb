require 'rubygems'
gem 'plugit'
require 'plugit'

Plugit.describe do |scenarios|
  scenarios.environments_root_path = File.dirname(__FILE__) + '/environments'
  
  scenarios.environment :default, 'Released versions of Rails and RSpec' do |env|
    env.library :rails, 'git', "git clone git://github.com/rails/rails.git" do |rails|
      rails.after_update { `git co v2.1.0_RC1` }
      rails.load_paths = %w{/activesupport/lib /activerecord/lib /actionpack/lib}
      rails.requires = %w{active_support active_record action_controller action_view}
    end
    env.library :rspec, 'git', "git clone git://github.com/dchelimsky/rspec.git" do |rspec|
      rspec.after_update { `git co 1.1.4` }
    end
    env.library :rspec_rails, 'git', "git clone git://github.com/dchelimsky/rspec-rails.git" do |rspec_rails|
      rspec_rails.after_update { `git co 1.1.4` }
    end
  end
end

# require File.expand_path(File.dirname(__FILE__) + "/../testing/environment")
# TESTING_ENVIRONMENTS[TESTING_ENVIRONMENT].load(DATABASE_ADAPTER)
# require "models"
# require "spec"
# require "spec/rails"
# require "scenarios"