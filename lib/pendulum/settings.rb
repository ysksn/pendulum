require 'hashie'

module Pendulum
  class Settings
    class << self
      def load(env)
        merge(load_from(:default), load_from(env))
      end

      private

      def load_from(env)
        path = File.join('environments', "#{env}.yml")
        return Hashie::Mash.new unless File.file?(path)
        Hashie::Mash.load(path)
      end

      def merge(org, new)
        org.deep_merge(new)
      end
    end
  end
end
