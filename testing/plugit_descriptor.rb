require 'rubygems'
gem 'plugit'
require 'plugit'

$LOAD_PATH << File.expand_path("#{File.dirname(__FILE__)}/../lib")
$LOAD_PATH << File.expand_path(File.dirname(__FILE__))
RAILS_ROOT = File.expand_path("#{File.dirname(__FILE__)}/..")

Plugit.describe do |scenarios|
  scenarios.environments_root_path = File.dirname(__FILE__) + '/environments'
  
  scenarios.environment :default, 'Released versions of Rails and RSpec' do |env|
    env.library :rails, :export => "git clone git://github.com/rails/rails.git" do |rails|
      rails.before_install { `git co v2.1.0_RC1` }
      rails.load_paths = %w{/activesupport/lib /activerecord/lib /actionpack/lib}
      rails.requires = %w{active_support active_record action_controller action_view}
    end
    env.library :rspec, :export => "git clone git://github.com/dchelimsky/rspec.git" do |rspec|
      rspec.before_install { `git co 1.1.4` }
      rspec.requires = %w{spec}
    end
    env.library :rspec_rails, :export => "git clone git://github.com/dchelimsky/rspec-rails.git" do |rspec_rails|
      rspec_rails.before_install { `git co 1.1.4` }
      rspec_rails.requires = %w{spec/rails}
    end
  end
  
  scenarios.environment :known, 'Last know working versions of Rails and RSpec' do |env|
    env.library :rails, :extends => scenarios[:default][:rails] do |rails|
      rails.before_install { `git co v2.1.0_RC1` }
    end
    env.library :rspec, :extends => scenarios[:default][:rspec] do |rspec|
      rspec.before_install { `git co 1.1.4` }
    end
    env.library :rspec_rails, :extends => scenarios[:default][:rspec_rails] do |rspec_rails|
      rspec_rails.before_install { `git co 1.1.4` }
    end
  end
end