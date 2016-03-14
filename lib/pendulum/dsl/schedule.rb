module Pendulum::DSL
  class Schedule
    include Helper

    attr_accessor :name

    def initialize(name, &block)
      self.name = name
      self.instance_eval(&block) if block_given?
    end

    define_setter :database, :query, :timezone,
                  :delay, :retry_limit, :type, :result_url

    def query_file(path)
      query(File.read(path))
    end

    def cron(cron)
      @cron = %i(hourly daily monthly).include?(cron) ? "@#{cron}" : cron
    end

    def priority(priority)
      @priority = priority.is_a?(Integer) ? priority : priority_id_of(priority)
    end

    def result(type, &block)
      result = Result.new(type, &block)
      @result_url = result.to_url
    end

    def to_params
      instance_variables.inject({}) do |params, v|
        params[v.to_s.delete('@').to_sym] = instance_variable_get(v)
        params
      end
    end

    def diff(current)
      default_params.merge(to_params).reject do |k, v|
        if k == :result_url
          equal_result_url?(current.result_url, v)
        else
          v == current.send(k)
        end
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

    def default_params
      {
        database:    '',
        query:       nil,
        retry_limit: 0,
        priority:    0,
        cron:        nil,
        timezone:    'Asia/Tokyo', # TODO: require timezone.
        delay:       0,
        result_url:  ''
      }
    end

    def equal_result_url?(current_url, new_url)
      current_uri = URI.parse(current_url)
      new_uri     = URI.parse(new_url)
      new_uri.password = '***'

      uri_without_query(current_uri) == uri_without_query(new_uri) &&
        query_hash(current_uri) == query_hash(new_uri)
    end

    def uri_without_query(uri)
      uri.to_s.split('?').first
    end

    def query_hash(uri)
      Hash[URI::decode_www_form(uri.query || '')]
    end
  end
end
