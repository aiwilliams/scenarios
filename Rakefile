require 'rubygems'
gem 'rake'
require 'rake'

desc "Run all specs in spec directory"
task :spec => "spec:environment" do
  Spec::Rake::SpecTask.new do |t|
    t.spec_opts = ['--options', "\"#{PLUGIN_ROOT}/spec/spec.opts\""]
    t.spec_files = FileList["#{PLUGIN_ROOT}/spec/**/*_spec.rb"]
  end
end

namespace :spec do
  desc "Prepare workspace for running our specs"
  task :environment do
    require File.dirname(__FILE__) + "/spec/environment"
    if File.directory?(RSPEC_ROOT)
      puts "Support libraries are in place. Skipping checkout."
    else
      system "svn export http://rspec.rubyforge.org/svn/trunk/rspec #{RSPEC_ROOT}"
      system "svn export http://rspec.rubyforge.org/svn/trunk/rspec_on_rails #{RSPEC_ON_RAILS_ROOT}"
      system "svn export http://svn.rubyonrails.org/rails/trunk/activerecord/ #{ACTIVERECORD_ROOT}"
      system "svn export http://svn.rubyonrails.org/rails/trunk/activesupport/ #{ACTIVESUPPORT_ROOT}"
    end
    require "#{RSPEC_ROOT}/lib/spec/rake/spectask"
  end
end
  
task :default => :spec