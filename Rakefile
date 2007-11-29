require 'rubygems'
gem 'rake'; require 'rake'
require 'rake/rdoctask'
require 'yaml'

require File.expand_path("#{File.dirname(__FILE__)}/app/environment")

def checkout_support_libs(additional = {})
  mkdir_p SUPPORT_LIB
  libs = {
    ACTIONPACK_ROOT     => "http://svn.rubyonrails.org/rails/trunk/actionpack/",
    ACTIVERECORD_ROOT   => "http://svn.rubyonrails.org/rails/trunk/activerecord/",
    ACTIVESUPPORT_ROOT  => "http://svn.rubyonrails.org/rails/trunk/activesupport/"
  }.merge(additional)
  needed = libs.keys.reject { |dir| File.directory?(dir) }
  if needed.empty?
    puts "Support libraries are in place. Skipping checkout."
  else
    needed.each { |root| system "svn export #{libs[root]} #{root}" }
  end
end

config = YAML.load(IO.read(DB_CONFIG_FILE))
databases = config.keys

desc "Run all specs using all databases"
task :spec => databases.map { |db| "spec:#{db}" }

desc "Run all unit tests using all databases"
task :test => databases.map { |db| "test:#{db}" }

databases.each do |db|
  namespace :spec do
    desc "Run all specs using #{db}"
    task db => "spec:prepare" do
      require "#{RSPEC_ROOT}/lib/spec/rake/spectask"
      puts "Running specs with #{db}..."
      Spec::Rake::SpecTask.new do |t|
        t.fail_on_error = false
        t.spec_opts = ['--options', "\"#{SPEC_ROOT}/spec.opts\""]
        t.spec_files = FileList["#{SPEC_ROOT}/**/*_spec.rb"]
      end
    end
    
    desc "Obtains necessary libraries and database"
    task :prepare => "db:#{db}:prepare" do
      checkout_support_libs(
        RSPEC_ROOT          => "http://rspec.rubyforge.org/svn/trunk/rspec/",
        RSPEC_ON_RAILS_ROOT => "http://rspec.rubyforge.org/svn/trunk/rspec_on_rails/"
      )
    end
  end
  
  namespace :test do
    desc "Run all unit tests using #{db}"
    task db => "test:prepare" do
      require 'rake/testtask'
      puts "Run unit tests with #{db}..."
      Rake::TestTask.new do |t|
        t.pattern = 'test/**/*_test.rb'
        t.verbose = true
      end
    end
    
    desc "Obtains necessary libraries and database"
    task :prepare => "db:#{db}:prepare" do
      checkout_support_libs
    end
  end
  
  desc "Cleanup generated assets"
  task :clean do
    rm_rf SUPPORT_LIB
    puts "cleaned #{SUPPORT_LIB}"
  end
  
  desc "Prepare the #{db} database"
  task "db:#{db}:prepare" do
    ENV['DB'] = db
    cd PLUGIN_ROOT do
      name = config[db][:database]
      case db
      when "mysql"
        system "mysqladmin -uroot drop #{name} --force"
        system "mysqladmin -uroot create #{name}"
      when "sqlite3"
        rm_rf name
        touch name
      else
        raise "Unknown database #{db}"
      end
      require "#{ACTIVERECORD_ROOT}/lib/activerecord"
      ActiveRecord::Base.silence do
        ActiveRecord::Base.configurations = config
        ActiveRecord::Base.establish_connection db
        load DB_SCHEMA_FILE
      end
    end
  end
end

Rake::RDocTask.new(:doc) do |r|
  r.title = "Rails Scenarios Plugin"
  r.main = "README"
  r.options << "--line-numbers"
  r.rdoc_files.include("README", "LICENSE", "lib/**/*.rb")
  r.rdoc_dir = "doc"
end
  
task :default do
  cd PLUGIN_ROOT do
    system "rake spec && rake test"
  end
end