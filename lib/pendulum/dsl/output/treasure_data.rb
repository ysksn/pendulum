module Pendulum::DSL::Output
  class TreasureData < Base
    def database(database)
      @database = database
    end

    def table(table)
      @table = table
    end

    def mode(mode)
      @mode = mode
    end

    def to_url
      url = "td://@/#{@database}/#{@table}"
      url = "#{url}?mode=#{@mode}" if @mode
      url
    end
  end
end
