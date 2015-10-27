require 'sinatra/base'
require 'blocktrain'
require 'json'

module SirHandel
  class App < Sinatra::Base
    set :public_folder, 'public'

    get '/' do
      @content = '<h1>Hello from TubePi</h1>'
      @title = 'TubePi'
      erb :index, layout: :default
    end

    get '/weight' do
      @params = URI.encode_www_form(params.delete_if { |k,v| v.nil? })

      erb :weight, layout: :default
    end

    get '/weight.json' do
      headers 'Access-Control-Allow-Origin' => '*'

      search = {
        from: params.fetch('from', '2015-09-01 00:00:00Z'),
        to: params.fetch('to', '2015-09-02 00:00:00Z'),
        interval: params.fetch('interval', '1h'),
        car: params['car']
      }

      r = Blocktrain::Aggregations::TrainWeightAggregation.new(search).results

      results = r["weight_chart"]["buckets"].map do |r|
        {
          "timestamp" => DateTime.strptime(r["key"].to_s, "%Q"),
          "value" => r["weight"]["value"]
        }
      end

      {
        results: results
      }.to_json
    end

    # start the server if ruby file executed directly
    run! if app_file == $0
  end
end
