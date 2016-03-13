require 'td'
require 'td-client'

module Pendulum
  class Client
    def initialize(api_key='', options={}, &block)
      @api_key = api_key
      @config = Configuration.new(options)
      @config.instance_eval(&block) if block_given?
    end

    def apply
      currents = current_schedules.map(&:name)

      @config.schedules.each do |schedule|
        if currents.include?(schedule.name)
          puts "Updating schedule: #{schedule.name}"
          update_schedule(schedule)
        else
          puts "Creating schedule: #{schedule.name}"
          create_schedule(schedule)
        end
      end

      (currents - @config.schedules.map(&:name)).each do |name|
        puts "Deleting schedule: #{name}"
        delete_schedule(name)
      end
    end

    def export(output)
      results = DSL::Converter.new(current_schedules).convert
      puts results
    end

    private

    def current_schedules
      td_client.schedules
    end

    def create_schedule(schedule)
      td_client.create_schedule(schedule.name, schedule.to_params)
    end

    def update_schedule(schedule)
      td_client.update_schedule(schedule.name, schedule.to_params)
    end

    def delete_schedule(name)
      td_client.delete_schedule(name)
    end

    def td_client
      @td_client ||= TreasureData::Client.new(@api_key, {ssl: true})
    end
  end
end
