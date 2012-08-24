# config.ru
require './web'
map "/fincal" do
  run Npv
end
