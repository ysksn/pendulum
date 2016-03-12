module Pendulum
  class Configuration
    def initialize(options={})
      if file = options[:file]
        self.instance_eval(File.read(file), file)
      end
    end

    def schedule(name, &block)
      schedules << Schedule.new(name, &block)
    end

    def schedules
      @schedules ||= []
    end
  end
end
