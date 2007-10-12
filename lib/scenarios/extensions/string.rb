class String
  def to_scenario
    "#{self.strip.camelize.sub(/Scenario$/, '')}Scenario".constantize
  end
end