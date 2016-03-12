module Pendulum::DSL::Output
  class TreasureData < Base
    define_setter :database, :table, :mode

    def to_url
      with_options("td://@/#{@database}/#{@table}", :mode)
    end
  end
end
