require 'sinatra/base'
require 'slim'

class Npv < Sinatra::Base
  configure do
    set :slim, :pretty => true
    set :sessions, true
  end

  get '/' do
    slim :index
  end
end
