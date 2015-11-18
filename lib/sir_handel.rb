require 'sinatra/base'
require 'blocktrain'
require 'json'
require 'rack/conneg'

require_relative 'sir_handel/helpers'
require_relative 'sir_handel/racks'

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

    get '/signals' do
      protected!
      @signals = Blocktrain::Lookups.instance.aliases.delete_if {|k,v| v.nil? }

      respond_to do |wants|
        # wants.html do
        #   @signal = params['signal']
        #   erb :weight, layout: :default
        # end

        wants.json do
          values = @signals.keys.map { |key| { name: key , url: SirHandel::build_url(key, request.base_url) } }

          { signals: values }.to_json
        end
      end
    end

    get '/signals/:signal' do
      protected!

      respond_to do |wants|
        # wants.html do
        #   @signals = Blocktrain::Lookups.instance.aliases.delete_if {|k,v| v.nil? }
        #   @signal = params['signal']
        #   erb :weight, layout: :default
        # end

        wants.json do
          headers 'Access-Control-Allow-Origin' => '*'

          search = {
            from: params.fetch('from', '2015-09-01 00:00:00Z'),
            to: params.fetch('to', '2015-09-02 00:00:00Z'),
            interval: params.fetch('interval', '1h'),
            signals: params.fetch('signal')
          }

          r = Blocktrain::Aggregations::AverageAggregation.new(search).results

          results = r['results']['buckets'].map do |r|
            {
              'timestamp' => DateTime.strptime(r['key'].to_s, '%Q'),
              'value' => r['average_value']['value']
            }
          end

          {
            results: results
          }.to_json
        end
      end
    end

    # start the server if ruby file executed directly
    run! if app_file == $0
  end

  def self.build_url path, base
    "#{base}/signals/#{path.gsub '_', '-'}.json"
  end
end
