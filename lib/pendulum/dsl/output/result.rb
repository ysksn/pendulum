module Pendulum::DSL::Output
  class Result < Base
    define_setter :table

    def initialize(name)
      @name = name
      super()
    end

    def to_url
      "#{@name}:#{@table}"
    end
  end
end
