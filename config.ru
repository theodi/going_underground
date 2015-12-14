require 'rack-timeout'

require_relative 'lib/blocktrain'
require_relative 'lib/sir_handel'

use Rack::Timeout
Rack::Timeout.timeout = ENV['SIR_HANDEL_TIMEOUT'].to_i || 30

map "/public" do
 run Rack::Directory.new("./public")
end

run SirHandel::App
