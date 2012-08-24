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
    slim :index, :locals => {:count => Value.count}
  end

  post '/' do
    puts params.inspect
    data = params["value"]
    value = Value.create(:name => data["name"],
                         :date => data["date"],
                         :amount => data["amount"],
                         :account_id => 1)
    value.save
    puts value.inspect
    redirect web_prefix+"/"
  end

  get '/data' do
    report = []
    Value.each do |value|
      report << {:title => "$#{"%0.2f" % value.amount} #{value.name}",
                 :start => value.date}

    end
    report << {:title => "rendered",
               :start => Time.now.strftime("%Y-%m-%d")}
    report.to_json
  end

end
