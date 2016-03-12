module Pendulum
  class Client
    def initialize(api_key='', options={}, &block)
      @api_key = api_key
      @config = Configuration.new(options)
      @config.instance_eval(&block) if block_given?
    end
  end
end
