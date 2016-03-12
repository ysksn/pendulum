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

    def to_params
      instance_variables.inject({}) do |params, v|
        params[v.to_s.delete('@').to_sym] = instance_variable_get(v)
        params
      end
    end
  end
end
