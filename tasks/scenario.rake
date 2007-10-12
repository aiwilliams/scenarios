namespace :db do
  namespace :scenario do
    desc "Load a scenario into the current environment's database using SCENARIO=scenario_name"
    task :load => 'db:reset' do
      scenario_name = ENV['SCENARIO'] || 'default'
      begin
        klass = Spec::Scenarios.load(scenario_name)
        puts "Loaded #{klass.name.underscore.gsub('_', ' ')}."
      rescue ArgumentError => e
        puts "Error! Set the SCENARIO environment variable or define a DefaultScenario class."
      rescue Spec::Scenarios::InvalidScenario => e
        puts "Error! Invalid scenario name [#{scenario_name}]."
      end
    end
  end
end