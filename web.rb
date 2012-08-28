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
    puts "/ #{params.inspect}"
    slim :index, :locals => {:count => Value.count}
  end

  post '/:number' do
    puts "post /:number #{params.inspect}"
    if params["action"] == "delete"
      value = Value.get(params["number"])
      value.destroy if value
    end
    redirect web_prefix+"/"
  end

  post '/' do
    puts "post / #{params.inspect}"
    data = params["value"]
    value = Value.create(:name => data["name"],
                         :date => data["date"],
                         :amount => data["amount"],
                         :account_id => 1)
    value.save
    redirect web_prefix+"/"
  end

  get '/data' do
    puts "/data #{params.inspect}"
    calendar_start = Date.parse(Time.at(params["start"].to_i).to_s)
    calendar_end = Date.parse(Time.at(params["end"].to_i).to_s)
    puts "data range #{calendar_start} #{calendar_end}"
    values = Value.all
    puts "values size #{values.size}"

    report = []
    first_day_total = Value.sum(:amount, :date.lte => calendar_start)
    first_day_total = 0 if first_day_total.nil?
    report_total = first_day_total
    (calendar_start..calendar_end).each do |day|
      puts "day report for #{day}"

      day_report = []
      today_values = values.select{|v| v.date.to_date == day}
      today_total = 0.0
      today_values.each do |value|
        background_color = value.amount > 0 ? "green" : "darkred"
        day_report << {:title => "$#{"%0.2f" % value.amount} #{value.name}",
                       :start => value.date, :backgroundColor => background_color,
                       :valueId => "#{value.id}"}
        today_total += value.amount
      end
      day_report << {:title => "$#{"%0.2f" % today_total} Day Total",
                 :start => day, :backgroundColor => "gray", :editable => false}
      report_total += today_total
      day_report << {:title => "$#{"%0.2f" % report_total} Balance",
                     :start => day, :editable => false}

      puts "adding day report to report"
      report += day_report.reverse
    end
    puts "data report is size #{report.size}"
    report.to_json
  end

end
