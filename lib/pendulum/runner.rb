require 'optparse'

module Pendulum
  class Runner
    def run(argv=ARGV)
      api_key = nil
      mode    = :apply
      options = {
        file: 'Schedfile',
        env:  :development
      }

      opt.on('-k', '--apikey=KEY')  {|v| api_key = v }
      opt.on('-f', '--file=FILE')   {|v| options[:file] = v }

      # apply
      opt.on('-E', '--environment=ENV') {|v| options[:env]  = v }

      # export
      opt.on('-e', '--export')      { mode   = :export }

      opt.parse!(argv) rescue return usage $!

      begin
        client = Client.new(api_key, options)
        case mode
        when :apply
          client.apply
        when :export
          client.export(options[:file])
        end
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
