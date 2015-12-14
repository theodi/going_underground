require 'rack-timeout'

require_relative 'lib/blocktrain'
require_relative 'lib/sir_handel'

use Rack::Timeout
Rack::Timeout.timeout = 60

map "/public" do
 run Rack::Directory.new("./public")
end

run SirHandel::App
