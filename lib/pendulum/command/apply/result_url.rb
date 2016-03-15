module Pendulum::Command
  class Apply
    class ResultURL
      attr_accessor :from, :to
      def initialize(from, to)
        self.from = from
        self.to   = to
      end

      def changed?
        from_uri = URI.parse(from)
        to_uri   = URI.parse(to)
        to_uri.password = '***'

        uri_without_query(from_uri) != uri_without_query(to_uri) ||
          query_hash(from_uri) != query_hash(to_uri)
      end

      private

      def uri_without_query(uri)
        uri.to_s.split('?').first
      end

      def query_hash(uri)
        Hash[URI::decode_www_form(uri.query || '')]
      end
    end
  end
end
