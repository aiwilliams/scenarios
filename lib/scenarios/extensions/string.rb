class String
  def to_scenario
    class_name = "#{self.strip.camelize.sub(/Scenario$/, '')}Scenario"

    Scenario.load_paths.each do |path|
      filename = "#{path}/#{class_name.underscore}.rb"
      if File.file?(filename)
        require filename
        break
      end
    end
    
    class_name.constantize rescue raise NameError, "Expected to find #{class_name} in #{Scenario.load_paths.inspect}"
  end
end