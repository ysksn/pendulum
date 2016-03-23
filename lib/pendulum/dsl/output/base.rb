module Pendulum::DSL::Output
  class Base
    include Pendulum::DSL::Helper

    def initialize(&block)
      self.instance_eval(&block) if block_given?
    end

    def to_url
      raise NotImplementedError, "You must implement #{self.class}##{__method__}"
    end

    private

    def with_options(url, *options)
      params = (options || []).select do |option|
        instance_variable_defined?("@#{option}")
      end.map do |option|
        "#{option}=#{instance_variable_get("@#{option}")}"
      end.join('&')
      url + (params.empty? ? '' : "?#{params}")
    end

    def x_and_y(x, y)
      case
      when x && y
        "#{x}:#{y}"
      when x
        x
      when y
        ":#{y}"
      end
    end
  end
end
