require 'sinatra/base'
require 'slim'
require 'json'
require 'active_record'
Dir['lib/*.rb'].each{|rb| require_relative rb[0,rb.length-3]}

class Npv < Sinatra::Base

  SETTINGS=YAML.load(File.open("settings.yml"))

  configure do
    db_creds = YAML.load_file("database.yml")
    appfog_creds = ENV['VCAP_SERVICES']
    if appfog_creds
      appfog_creds = JSON.parse(appfog_creds).map{|k,v| v}.flatten
      puts appfog_creds.inspect
      dbs = appfog_creds.select{|e| e["tags"].include?(db_creds["adapter"])}
      db_creds.merge!(dbs.first["credentials"])
    end
    ActiveRecord::Base.establish_connection(db_creds)
    ActiveRecord::Migrator.migrate('db/migrate')
    set :slim, :pretty => true
    use Rack::Session::Cookie,
             :expire_after => 15552000, #6 months
             :secret => SETTINGS['session_secret']
  end

  helpers do
    def web_prefix
      ""
    end

    def adsense_setup
      if SETTINGS["adsense"]
        "
        google_ad_client = \"#{SETTINGS["adsense"]["client"]}\";
        google_ad_slot = \"#{SETTINGS["adsense"]["slot"]}\";
        google_ad_width = \"#{SETTINGS["adsense"]["width"]}\";
        google_ad_height = \"#{SETTINGS["adsense"]["height"]}\";
        "
      end
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
                         :session_id => session["id"],
                         :created_at => Time.now)
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

  get '/stats.?:format?' do
    if params[:format] == 'json'
      JSON.pretty_generate({values: {count: Value.count,
                                     day_change: Value.where(['created_at > ?', Time.now-(60*60*24)])
                                      .count}})
    else
      slim :stats
    end
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
