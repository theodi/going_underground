require 'sinatra/base'
require 'blocktrain'
require 'json'
require 'rack/conneg'

require 'sir_handel/helpers'
require 'sir_handel/racks'

Dotenv.load

module SirHandel
  class App < Sinatra::Base
    set :public_folder, 'public'
    set :views, 'views'

    get '/' do
      @content = '<h1>Hello from TubePi</h1>'
      @title = 'TubePi'
      erb :index, layout: :default
    end

    get '/signal' do
      protected!

      respond_to do |wants|
        wants.html do
          @signals = Blocktrain::Lookups.instance.lookups
          erb :weight, layout: :default
        end

        wants.json do
          headers 'Access-Control-Allow-Origin' => '*'

          search = {
            from: params.fetch('from', '2015-09-01 00:00:00Z'),
            to: params.fetch('to', '2015-09-02 00:00:00Z'),
            interval: params.fetch('interval', '1h'),
            signals: 'train_speed'
          }

          r = Blocktrain::Aggregations::AverageAggregation.new(search).results

          results = r['results']['buckets'].map do |r|
            {
              'timestamp' => DateTime.strptime(r['key'].to_s, '%Q'),
              'value' => r['average_value']['value']
            }
          end

          {
            min: results.min_by { |h| h['value'] }['value'],
            max: results.max_by { |h| h['value'] }['value'],
            results: results
          }.to_json
        end
      end
    end

    # start the server if ruby file executed directly
    run! if app_file == $0
  end
end
