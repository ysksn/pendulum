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

    def apply(dry_run: false, force: false, color: false)
      Pendulum::Command::Apply.new(
        td_client,
        current_schedules,
        @config.schedules,
        dry_run,
        force,
        color,
      ).execute
    end

    def export(output)
      result = DSL::Converter.new(td_client.schedules).convert
      # schedule
      File.write(output, result[:schedule])
      # queries
      query_dir = File.join(File.dirname(output), 'queries')
      make_dir(query_dir)
      result[:queries].each do |query|
        File.write(File.join(query_dir, query[:name]), query[:query])
      end
    end

    private

    def current_schedules
      td_client.schedules
    end

    def td_client
      @td_client ||= TreasureData::Client.new(@api_key, {ssl: true})
    end

    def make_dir(dir)
      FileUtils.mkdir(dir) unless File.exist?(dir)
    end
  end
end
