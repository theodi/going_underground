require 'rack-timeout'

use Rack::Timeout
Rack::Timeout.timeout = ENV['SIR_HANDEL_TIMEOUT'].to_i || 30

require_relative 'lib/blocktrain'
require_relative 'lib/sir_handel'

map "/public" do
 run Rack::Directory.new("./public")
end

run SirHandel::App
