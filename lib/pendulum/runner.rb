require 'optparse'

module Pendulum
  class Runner
    def run(argv=ARGV)
      api_key = nil
      options = {file: 'Schedfile'}

      opt.on('-f', '--file=FILE')  {|v| options[:file]    = v }
      opt.on('-k', '--apikey=KEY') {|v| api_key           = v }

      opt.parse!(argv) rescue return usage $!

      begin
        client = Client.new(api_key, options)
        client.apply
      rescue
        puts $!
        return 1
      end

      return 0
    end

    private

    def usage(err)
      puts err if err
      puts @opt.help
      err ? 1 : 0
    end

    def opt
      @opt ||= OptionParser.new
    end
  end
end
