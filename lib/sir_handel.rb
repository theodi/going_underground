require 'sinatra/base'
require 'blocktrain'
require 'json'
require 'rack/conneg'

#require_relative 'sir_handel/helpers'

Dotenv.load

module SirHandel
  class App < Sinatra::Base
    set :public_folder, 'public'

    use(Rack::Conneg) do |conneg|
      conneg.set :accept_all_extensions, false
      conneg.set :fallback, :html
      conneg.provide([:html, :json])
    end

    before do
      if negotiated?
        content_type negotiated_type
      end
    end

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
            min: results.min_by { |h| h['value'] }["value"],
            max: results.max_by { |h| h['value'] }["value"],
            results: results
          }.to_json
        end
      end
    end

    # start the server if ruby file executed directly
    run! if app_file == $0

  helpers do
    def protected!
      return if ENV['RACK_ENV'] == 'test'
      return if authorized?
      headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
      halt 401, "Not authorized\n"
    end

    def authorized?
      @auth ||= Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? and
        @auth.basic? and
        @auth.credentials and
        @auth.credentials == [
          ENV['TUBE_USERNAME'],
          ENV['TUBE_PASSWORD']
        ]
      end
    end
  end
end
