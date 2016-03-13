require 'optparse'

module Pendulum
  class Runner
    def run(argv=ARGV)
      api_key = nil
      mode    = :apply
      output  = 'Schedfile'
      options = {file: 'Schedfile'}

      opt.on('-k', '--apikey=KEY')  {|v| api_key = v }

      # apply
      opt.on('-f', '--file=FILE')   {|v| options[:file] = v }

      # export
      opt.on('-e', '--export')      {    mode   = :export }
      opt.on('-o', '--output=FILE') {|v| output = v       }

      opt.parse!(argv) rescue return usage $!

      begin
        client = Client.new(api_key, options)
        case mode
        when :apply
          client.apply
        when :export
          client.export(output)
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
