require 'sinatra/base'
require 'slim'
require 'json'
require 'data_mapper'

class Npv < Sinatra::Base
  configure do
    set :slim, :pretty => true
    set :sessions, true
  end

  helpers do
    def web_prefix
      "/fincal"
    end
  end

  get '/' do
    slim :index
  end

  post '/' do
    puts params.inspect
  end

  get '/data' do
    [{:title => "rendered",
      :start => Time.now.strftime("%Y-%m-%d")}].to_json
  end

end
