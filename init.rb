Dependencies.load_paths << "#{config.root_path}/spec/scenarios"
if config.environment == "test"
  require 'spec/scenarios'
  require 'spec/rails'
  Dir[File.dirname(__FILE__) + '/lib/spec/scenarios/dsl/extensions/*.rb'].each { |f| require f }
end