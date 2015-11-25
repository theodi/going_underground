require 'sinatra/base'
require 'blocktrain'
require 'json'
require 'csv'
require 'rack/conneg'
require 'i18n'
require 'i18n/backend/fallbacks'
require 'redis'

require_relative 'sir_handel/helpers'
require_relative 'sir_handel/racks'
require_relative 'sir_handel/tasks'
require_relative 'sir_handel/lookups'
require_relative 'sir_handel/trends'

Dotenv.load

module SirHandel
  class App < Sinatra::Base

    helpers do
      include SirHandel::Helpers
    end

    set :public_folder, 'public'
    set :views, 'views'

    set :default_from, '2015-09-01T00:00:00+00:00'
    set :default_to, '2015-09-02T00:00:00+00:00'
    set :default_interval, '10m'

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

    get '/signals/:signal' do
      signal = params['signal']
      interval = params.fetch('interval', settings.default_interval)

      redirect to("/signals/#{signal}/#{settings.default_from}/#{settings.default_to}?interval=#{interval}")
    end

    get '/signals/:signal/:from/:to' do
      protected!

      @from = params[:from]
      @to = params[:to]
      @signal = params['signal']
      @interval = params.fetch('interval', '1h')

      respond_to do |wants|
        wants.html do
          @title = I18n.t @signal.gsub('-', '_')
          erb :signal, layout: :default
        end

        wants.json do
          headers 'Access-Control-Allow-Origin' => '*'
          with_trend(search).to_json
        end

        wants.csv do
          headers 'Access-Control-Allow-Origin' => '*'

          csv_headers = ['timestamp', @signal].to_csv

          body = CSV.generate do |csv|
            search[:results].each do |line|
              csv << [line['timestamp'].to_s, line['value']]
            end
          end

          "#{csv_headers}#{body}"
        end
      end
    end

    post '/signals/:signal' do
      params.delete_if { |k,v| v == '' }

      from = params.fetch('from', settings.default_from)
      to = params.fetch('to', settings.default_to)
      interval = params.fetch('interval', settings.default_interval)

      from = DateTime.parse(from).to_s
      to = DateTime.parse(to).to_s

      redirect to("/signals/#{params[:signal]}/#{from}/#{to}?interval=#{interval}")
    end

    get '/cromulent-dates' do
      redis = Redis.new(url: ENV['REDIS_URL'])
      redis.get('cromulent-dates') || SirHandel::Tasks.cromulise
    end

    def error_400(message)
      error 400, {:status => message}.to_json
    end

    def search
      check_dates

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
      }
    end

    def with_trend(search)
      search.merge(
        trend: Trend.new(search[:results], @from, @to).to_hash
      )
    end

    def check_dates
      invalid = []

      from = DateTime.parse(@from) rescue invalid << "'#{@from}' is not a valid ISO8601 date/time."
      to = DateTime.parse(@to) rescue invalid << "'#{@to}' is not a valid ISO8601 date/time."

      if invalid.count == 0
        invalid << "'from' date must be before 'to' date." if from > to
      end

      error_400(invalid.join(" ")) unless invalid.count == 0
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
