module Pendulum
  class Configuration
    def initialize(options={})
      settings = Pendulum::Settings.load(options[:env])
      if file = options[:file]
        self.instance_eval(File.read(file), file)
      end
    end

    def schedule(name, &block)
      schedules << DSL::Schedule.new(name, &block)
    end

    def schedules
      @schedules ||= []
    end
  end
end
