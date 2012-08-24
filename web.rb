require 'sinatra/base'
require 'slim'
require 'json'
require 'data_mapper'
Dir['lib/*'].each{|rb| require_relative rb[0,rb.length-3]}

class Npv < Sinatra::Base

  SETTINGS=YAML.load(File.open("settings.yml"))
  DataMapper.setup(:default, "postgres://root:supahsekret@127.0.0.1/dm_core_test")

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
