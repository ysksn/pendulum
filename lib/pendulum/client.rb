require 'td'
require 'td-client'
require 'fileutils'

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
          if schedule.diff(current_schedules.find{|s| s.name == schedule.name}).empty?
            puts "No change:         #{schedule.name}"
          else
            puts "Updating schedule: #{schedule.name}"
            update_schedule(schedule)
          end
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
      result = DSL::Converter.new(td_client.schedules).convert
      # schedule
      File.write(output, result[:schedule])
      # queries
      query_dir = File.join(File.dirname(output), 'query')
      make_dir(query_dir)
      result[:queries].each do |query|
        File.write(File.join(query_dir, query[:name]), query[:query])
      end
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

    def make_dir(dir)
      FileUtils.mkdir(dir) unless File.exist?(dir)
    end
  end
end
