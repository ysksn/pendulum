require 'erb'

module Pendulum::DSL
  class Converter
    def initialize(schedules)
      @schedules = schedules
    end

    def convert
      result = {}
      result[:schedule] = @schedules.map do |schedule|
        to_dsl(schedule)
      end.join("\n")

      result[:queries] = @schedules.inject({}) do |queries, schedule|
        queries.merge(to_query(schedule))
      end

      result
    end

    private

    def to_dsl(schedule)
      ERB.new(<<-EOS, nil, '-').result(binding)
schedule '<%= schedule.name %>' do
  database:   '<%= schedule.database %>'
<% if schedule.query -%>
  query_file: 'query/<%= schedule.name %>.hql'
  # type:     :hive # FIXME: Treasure Data schedule api dosen't contain type result.
  retry:      <%= schedule.retry_limit %>
  priority:   <%= schedule.priority %>
<% end -%>
<% if schedule.cron -%>
  cron:       '<%= schedule.cron %>'
  timezone:   '<%= schedule.timezone %>'
  delay:      <%= schedule.delay %>
<% end -%>
<% if schedule.result_url != '' -%>
  result_url: '<%= schedule.result_url %>'
<% end -%>
end
      EOS
    end

    def to_query(schedule)
      return {} unless schedule.query
      {name: schedule.name, query: schedule.query}
    end
  end
end
