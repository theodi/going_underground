require_relative 'lib/blocktrain'
require_relative 'lib/sir_handel'

map "/public" do
 run Rack::Directory.new("./public")
end

run SirHandel::App
