require 'sinatra/base'
require 'slim'
require 'json'
require 'data_mapper'
Dir['lib/*'].each{|rb| require_relative rb[0,rb.length-3]}

class Npv < Sinatra::Base

  SETTINGS=YAML.load(File.open("settings.yml"))
  DataMapper.setup(:default, SETTINGS["db"])
  DataMapper.auto_upgrade!

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
    slim :index, :locals => {:count => Account.count}
  end

  post '/' do
    puts params.inspect
  end

  get '/data' do
    [{:title => "rendered",
      :start => Time.now.strftime("%Y-%m-%d")}].to_json
  end

end
