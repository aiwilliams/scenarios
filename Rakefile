require 'rubygems'
gem 'rake'
require 'rake'

desc "Run all specs in spec directory"
task :spec => "spec:libs:checkout" do
  require "#{RSPEC_ROOT}/lib/spec/rake/spectask"
  Spec::Rake::SpecTask.new do |t|
    t.spec_opts = ['--options', "\"#{PLUGIN_ROOT}/spec/spec.opts\""]
    t.spec_files = FileList["#{PLUGIN_ROOT}/spec/**/*_spec.rb"]
  end
end

namespace :spec do
  desc "Load environment into rake file"
  task :environment do
    require File.dirname(__FILE__) + "/spec/environment"
  end
  
  namespace :libs do
    desc "Prepare workspace for running our specs"
    task :checkout => :environment do
      mkdir_p SUPPORT_LIB
      libs = {
        RSPEC_ROOT          => "http://rspec.rubyforge.org/svn/trunk/rspec",
        RSPEC_ON_RAILS_ROOT => "http://rspec.rubyforge.org/svn/trunk/rspec_on_rails",
        ACTIVERECORD_ROOT   => "http://svn.rubyonrails.org/rails/trunk/activerecord/",
        ACTIVESUPPORT_ROOT  => "http://svn.rubyonrails.org/rails/trunk/activesupport/"
      }
      needed = libs.keys.select { |dir| not File.directory?(dir) }
      if needed.empty?
        puts "Support libraries are in place. Skipping checkout."
      else
        needed.each { |root| system "svn export #{libs[root]} #{root}" }
      end
    end
    
    desc "Remove libs from tmp directory"
    task :clean => :environment do
      rm_rf SUPPORT_LIB
      puts "cleaned #{SUPPORT_LIB}"
    end
  end
end
  
task :default => :spec