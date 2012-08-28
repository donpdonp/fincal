# config.ru
require 'rack/coffee'
require './web'

use Rack::CommonLogger
use Rack::Coffee, {
    :root => File.dirname(__FILE__) + '/public',
    :urls => '/js'
  }

run Npv
