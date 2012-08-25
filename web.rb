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
    puts params.inspect
    calendar_start = Date.parse(Time.at(params["start"].to_i).to_s)
    calendar_end = Date.parse(Time.at(params["end"].to_i).to_s)
    puts "#{calendar_start} #{calendar_end}"
    values = Value.all
    puts values.inspect

    report = []
    first_day_total = Value.sum(:amount, :date.lte => calendar_start)
    first_day_total = 0 if first_day_total.nil?
    report_total = first_day_total
    (calendar_start..calendar_end).each do |day|

      day_report = []
      today_values = values.select{|v| v.date.to_date == day}
      today_total = 0.0
      today_values.each do |value|
        background_color = value.amount > 0 ? "green" : "darkred"
        day_report << {:title => "$#{"%0.2f" % value.amount} #{value.name}",
                       :start => value.date, :backgroundColor => background_color}
        today_total += value.amount
      end
      day_report << {:title => "$#{"%0.2f" % today_total} Day Total",
                 :start => day, :backgroundColor => "gray", :editable => false}
      report_total += today_total
      day_report << {:title => "$#{"%0.2f" % report_total} Balance",
                     :start => day, :editable => false}

      report += day_report.reverse
    end
    report.to_json
  end

end
