module Pendulum::DSL
  class Result
    attr_accessor :type

    def initialize(type, &block)
      self.type = type
      @output = output_by(type)
      @output.instance_eval(&block) if block_given?
    end

    private

    def output_by(type)
      case type.to_sym
      when :treasure_data, :td
        Output::TreasureData.new
      end
    end
  end
end
