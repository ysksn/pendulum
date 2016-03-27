module Pendulum::DSL::Output
  class Postgresql < Base
    define_setter :username, :password, :hostname, :port,
                  :database, :table, :ssl, :schema, :mode, :method

    def to_url
      url = "postgresql://#{username_and_password}@#{hostname_and_port}/#{@database}/#{@table}"
      with_options(url, :ssl, :schema, :mode, :method)
    end
  end
end
