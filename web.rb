require 'sinatra/base'
require 'slim'
require 'json'
require 'active_record'
Dir['lib/*'].each{|rb| require_relative rb[0,rb.length-3]}

class Npv < Sinatra::Base

  SETTINGS=YAML.load(File.open("settings.yml"))
  ActiveRecord::Base.establish_connection(YAML.load_file("database.yml"))

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
    session["id"] ||= rand(36**6).to_s(36)
    slim :index, :locals => {}
  end

  get '/s/:number' do
    puts "/s/#{params["number"]}"
    session["id"] = params["number"]
    puts session.inspect
    redirect web_prefix+"/"
  end

  post '/:number' do
    puts "post /:number #{params.inspect}"
    if params["action"] == "delete"
      value = value_session_query.find(params["number"])
      value.destroy if value
    end
    redirect web_prefix+"/"
  end

  post '/' do
    puts "post / #{params.inspect}"
    data = params["value"]
    value = value_session_query.create!(:name => data["name"],
                         :date => data["date"],
                         :amount => data["amount"],
                         :session_id => session["id"])
    redirect web_prefix+"/"
  end

  get '/data' do
    puts "/data #{params.inspect}"
    day_start = Date.parse(Time.at(params["start"].to_i).to_s)
    day_end = Date.parse(Time.at(params["end"].to_i).to_s)
    puts "data range #{day_start} #{day_end}"
    report = build_calendar_report(day_start, day_end)
    report.flatten.to_json
  end

  private

  def value_session_query
    Value.where({session_id:session["id"]})
  end

  def build_calendar_report(day_start, day_end)
    previous_days_total = value_session_query.where(["date < ?", day_start]).sum(:amount)
    report_total = previous_days_total
    (day_start..day_end).map do |day|

      day_report = []
      today_values = value_session_query.where({date:day})
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

      day_report.reverse
    end
  end

end
