require 'sinatra/base'
require 'blocktrain'
require 'json'

Dotenv.load

module SirHandel
  class App < Sinatra::Base
    set :public_folder, 'public'

    get '/' do
      @content = '<h1>Hello from TubePi</h1>'
      @title = 'TubePi'
      erb :index, layout: :default
    end

    get '/signal' do
      @signals = Blocktrain::Lookups.instance.lookups
      erb :weight, layout: :default
    end

    get '/signal.json' do
      content_type :json
      headers 'Access-Control-Allow-Origin' => '*'

      search = {
        from: params.fetch('from', '2015-09-01 00:00:00Z'),
        to: params.fetch('to', '2015-09-02 00:00:00Z'),
        interval: params.fetch('interval', '1h'),
        signal: params.fetch('signal', 'train_speed')
      }

      r = Blocktrain::Aggregations::AverageAggregation.new(search).results

      results = r['results']['buckets'].map do |r|
        {
          'timestamp' => DateTime.strptime(r['key'].to_s, '%Q'),
          'value' => r['average_value']['value']
        }
      end

      {
        max: results.min_by { |h| h['value'] }["value"],
        min: results.max_by { |h| h['value'] }["value"],
        results: results
      }.to_json
    end

    # start the server if ruby file executed directly
    run! if app_file == $0
  end
end
