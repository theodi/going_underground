require 'sinatra/base'
require 'blocktrain'
require 'json'
require 'rack/conneg'
require 'i18n'
require 'i18n/backend/fallbacks'
require 'redis'

require_relative 'sir_handel/helpers'
require_relative 'sir_handel/racks'
require_relative 'sir_handel/tasks'

Dotenv.load

module SirHandel
  class App < Sinatra::Base

    helpers do
      include SirHandel::Helpers
    end

    set :public_folder, 'public'
    set :views, 'views'

    get '/' do
      redirect to('/signals')
    end

    get '/signals' do
      protected!
      @title = 'Available signals'
      @signals = Blocktrain::Lookups.instance.aliases.delete_if {|k,v| v.nil? }

      respond_to do |wants|
        wants.html do
          erb :signals, layout: :default
        end

        wants.json do
          values = @signals.keys.map { |key| { name: key , url: SirHandel::build_url(key, request.base_url) } }

          { signals: values }.to_json
        end
      end
    end

    get '/signals/:signal/?:from?/?:to?' do
      protected!

      @signal = params['signal']
      @from = params.fetch('from', '2015-09-01 00:00:00Z')
      @to = params.fetch('to', '2015-09-02 00:00:00Z')
      @interval = params.fetch('interval', '1h')

      @title = I18n.t @signal.gsub('-', '_')

      respond_to do |wants|
        wants.html do
          erb :signal, layout: :default
        end

        wants.json do
          headers 'Access-Control-Allow-Origin' => '*'

          search = {
            from: @from,
            to: @to,
            interval: @interval,
            signals: SirHandel::parameterize_signal(@signal)
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

    post '/signals/:signal' do
      params.delete_if { |k,v| v == '' }

      from = params.fetch('from', '2015-09-01 00:00:00Z')
      to = params.fetch('to', '2015-09-02 00:00:00Z')
      interval = params.fetch('interval', '10m')

      from = DateTime.parse(from).to_s
      to = DateTime.parse(to).to_s

      redirect to("/signals/#{params[:signal]}/#{from}/#{to}?interval=#{interval}")
    end

    get '/cromulent-dates' do
    #  require 'pry' ; binding.pry
      redis = Redis.new(url: ENV['REDIS_URL'])
      redis.get('cromulent-dates') || SirHandel::Tasks.cromulise
    end

    # start the server if ruby file executed directly
    run! if app_file == $0
  end

  def self.build_url path, base, format = '.json'
    "#{base}/signals/#{path.gsub '_', '-'}#{format}"
  end

  def self.parameterize_signal signal
    signal.gsub('-', '_')
  end
end
