module Pendulum::DSL
  module Helper
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def define_setter(*names)
        names.each do |name|
          define_method(name) do |value|
            instance_variable_set("@#{name}", value)
          end
        end
      end
    end
  end
end
