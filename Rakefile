require File.expand_path(File.dirname(__FILE__) + '/testing/plugit_descriptor')

require 'rake/rdoctask'
# require 'rake/testtask'
# require "spec/rake/spectask"

# desc "Run specs in #{ENV['PLUGIT_ENV']} environment. Change using ENV['PLUGIT_ENV']."
# Spec::Rake::SpecTask.new :spec do |t|
#   t.fail_on_error = false
#   t.spec_files = FileList["spec/*_spec.rb"]
#   t.verbose = false
# end
# 
# desc "Run tests in environment of ENV['PLUGIT_ENV']"
# Rake::TestTask.new :test do |t|
#   t.test_files = FileList["test/**/*_test.rb"]
#   t.verbose = false
# end
# 
Rake::RDocTask.new(:doc) do |r|
  r.title = "Rails Scenarios Plugin"
  r.main = "README"
  r.options << "--line-numbers"
  r.rdoc_files.include("README", "LICENSE", "lib/**/*.rb")
  r.rdoc_dir = "doc"
end
# 
# task :default => [:spec, :test]