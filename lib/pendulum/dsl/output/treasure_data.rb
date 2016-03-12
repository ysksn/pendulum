module Pendulum::DSL::Output
  class TreasureData < Base
    include Pendulum::DSL::Helper

    define_setter :database, :table, :mode

    def to_url
      url = "td://@/#{@database}/#{@table}"
      url = "#{url}?mode=#{@mode}" if @mode
      url
    end
  end
end
