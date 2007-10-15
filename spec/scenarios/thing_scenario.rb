class ThingScenario < Scenario::Base
  
  helpers do
    def create_thing(attributes)
      attributes = thing_params(attributes)
      create_record(:thing, attributes[:name].symbolize, attributes)
    end
    def thing_params()
      attributes = {
        :name        => "Unnamed Thing",
        :description => "I'm not sure what this is."
      }.update(attributes)
    end
  end
  
end