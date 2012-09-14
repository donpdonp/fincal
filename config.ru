# config.ru
require './web'

use Rack::CommonLogger
run Npv
