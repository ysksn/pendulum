module Pendulum
  class Schedule
    attr_accessor :name

    def initialize(name, &block)
      self.name = name
      self.instance_eval(&block) if block_given?
    end

    def database(database)
      @database = database
    end

    def query(query)
      @query = query
    end

    def query_file(path)
      query(File.read(path))
    end

    def cron(cron)
      @cron = cron
    end

    def timezone(timezone)
      @timezone = timezon
    end

    def delay(delay)
      @delay = delay
    end

    def retry_limit(retry_limit)
      @retry_limit = retry_limit
    end

    def type(type)
      @type = type
    end

    def priority(priority)
      @priority = priority.is_a?(Integer) ? priority : priority_id_of(priority)
    end

    def to_params
      instance_variables.inject({}) do |params, v|
        params[v.to_s.delete('@').to_sym] = instance_variable_get(v)
        params
      end
    end

    private

    def priority_id_of(name)
      case name.to_sym
      when :very_low  then -2
      when :low       then -1
      when :normal    then  0
      when :high      then  1
      when :very_high then  2
      else                  0
      end
    end
  end
end
