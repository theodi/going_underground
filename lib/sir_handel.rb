require 'sinatra/base'
require 'json'
require 'csv'
require 'rack/conneg'
require 'i18n'
require 'i18n/backend/fallbacks'
require 'redis'
require 'tilt/erubis'

require_relative 'blocktrain'
require_relative 'sir_handel/helpers'
require_relative 'sir_handel/racks'
require_relative 'sir_handel/tasks'
require_relative 'sir_handel/trends'

Dotenv.load

module SirHandel
  class App < Sinatra::Base

    helpers do
      include SirHandel::Helpers
    end

    set :public_folder, 'public'
    set :views, 'views'

    set :default_interval, '10m'

    get '/' do
      redirect to('/signals')
    end

    get '/signals' do
      protected!

      @title = 'Available signals'
      @signals = Blocktrain::Lookups.instance.aliases.delete_if {|k,v| v.nil? }

      respond_to do |wants|
        headers 'Vary' => 'Accept'

        wants.html do
          erb :signals, layout: :default
        end

        wants.json do
          values = @signals.keys.map do |key|
            { name: key, url: url(signal_path(key, :json)) }
          end

          { signals: values }.to_json
        end
      end
    end

    get '/signals/:signal' do
      signal = params['signal']
      interval = params.fetch('interval', settings.default_interval)

      redirect to("/signals/#{signal}/#{default_dates[:from]}/#{default_dates[:to]}?interval=#{interval}")
    end

    get '/signals/:signal/:from/:to' do
      protected!

      @from = params[:from]
      @to = params[:to]
      @signal = params['signal']
      @interval = params.fetch('interval', '1h')

      respond_to do |wants|
        headers 'Vary' => 'Accept'

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

      from = params.fetch('from', default_dates[:from])
      to = params.fetch('to', default_dates[:to])
      interval = params.fetch('interval', settings.default_interval)

      from = DateTime.parse(from).to_s
      to = DateTime.parse(to).to_s

      redirect to("/signals/#{params[:signal]}/#{from}/#{to}?interval=#{interval}")
    end

    get '/cromulent-dates' do
      cromulent_dates
    end

    # start the server if ruby file executed directly
    run! if app_file == $0
  end

end
