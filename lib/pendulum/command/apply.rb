module Pendulum::Command
  class Apply
    attr_accessor :client, :dry_run, :force

    def initialize(client, from, to, dry_run=false, force=false, color=false)
      @schedules = matched_schedules(client, from, to, dry_run, force, color)
    end

    def execute
      @schedules.each{|s| s.apply }
    end

    private

    def matched_schedules(client, from, to, dry_run, force, color)
      # create or update
      schedules = to.map do |schedule|
        Schedule.new(
          client,
          from.find{|f| f.name == schedule.name},
          schedule,
          dry_run,
          force,
          color
        )
      end

      # delete
      from.reject{|f| to.any?{|t| t.name == f.name}}.each do |schedule|
        schedules << Schedule.new(client, schedule, nil, dry_run, force, color)
      end
      schedules
    end
  end
end
