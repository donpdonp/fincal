# config.ru
require 'rack/coffee'
require './web'

use Rack::Coffee, {
    :root => File.dirname(__FILE__) + '/public',
    :urls => '/js'
  }

map "/fincal" do
  run Npv
end
