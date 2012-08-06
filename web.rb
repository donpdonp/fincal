require 'sinatra/base'
require 'slim'
require 'json'

class Npv < Sinatra::Base
  configure do
    set :slim, :pretty => true
    set :sessions, true
  end

  get '/' do
    slim :index
  end

  get '/data' do
    [{:title => "rendered",
      :start => Time.now.strftime("%Y-%m-%d")}].to_json
  end
end
