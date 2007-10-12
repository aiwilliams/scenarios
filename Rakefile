require 'rubygems'
gem 'rake'
gem 'rspec'

require 'rake'
require 'spec'
require 'spec/rake/spectask'

PLUGIN_ROOT = File.dirname(__FILE__)

desc "Run all specs in spec directory"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts = ['--options', "\"#{PLUGIN_ROOT}/spec/spec.opts\""]
  t.spec_files = FileList["#{PLUGIN_ROOT}/spec/**/*_spec.rb"]
end

task :default => :spec