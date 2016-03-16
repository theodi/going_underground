require 'sinatra/base'
require 'json'
require 'csv'
require 'rack/conneg'
require 'i18n'
require 'i18n/backend/fallbacks'
require 'redis'
require 'tilt/erubis'
require 'connection_pool'
require 'dalli'
require 'kramdown'

require_relative 'blocktrain'
require_relative 'sir_handel/helpers'
require_relative 'sir_handel/racks'
require_relative 'sir_handel/tasks'
require_relative 'sir_handel/trends'
require_relative 'sir_handel/next_trains'

Dotenv.load

class DateTime
  def to_s
    strftime('%Y-%m-%dT%H:%M:%S.%L%:z')
  end
end

module SirHandel
  class App < Sinatra::Base
    helpers do
      include SirHandel::Helpers
    end

    DEFAULT_DATE = YAML.load_file('config/defaults.yml')['date']

    cache = Dalli::Client.new((ENV["MEMCACHIER_SERVERS"] || "").split(","),
                              {:username => ENV["MEMCACHIER_USERNAME"],
                               :password => ENV["MEMCACHIER_PASSWORD"],
                               :failover => true,
                               :socket_timeout => 1.5,
                               :socket_failure_delay => 0.2,
                               :pool_size => 5
                              })

    set :cache, cache
    set :public_folder, 'public'
    set :views, 'views'
    set :raise_errors, ['cucumber', 'test'].include?(ENV['RACK_ENV'])

    set :default_interval, '10m'

    before do
      protected!
    end

    get '/' do
      respond_to do |wants|
        @title = 'Train Data Demonstrator'

        wants.html do
          erb :index, layout: :default
        end

        wants.json do
          {
            signals: "#{request.scheme}://#{request.env['HTTP_HOST']}/signals",
            stations: "#{request.scheme}://#{request.env['HTTP_HOST']}/stations"
          }.to_json
        end
      end
    end

    get '/signals' do
      @title = 'Available signals'
      @signals = lookups
      @groups = groups

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

    get '/signals/:signals/:from/:to' do
      @from = params[:from]
      @to = params[:to]
      @signals = params['signals']
      @interval = params[:interval]

      @layout = params.fetch('layout', 'default')

      @signal_array = @signals.split(',')

      error_400('Please set a maximum of two signals') if @signal_array.count > 2

      respond_to do |wants|
        headers 'Vary' => 'Accept'

        wants.html do
          @signal_list = lookups

          signals = @signal_array.map { |s| I18n.t(db_signal(s)) }
          @title = signals.join(' compared with ')
          erb :signal, layout: @layout.to_sym
        end

        wants.json do
          headers 'Access-Control-Allow-Origin' => '*'

          {
            signals: get_results
          }.to_json
        end

        wants.csv do
          headers 'Access-Control-Allow-Origin' => '*'

          csv_headers = ['timestamp', *@signal_array].to_csv
          results = get_results

          body = CSV.generate do |csv|
            r1 = results[0][:results]
            r2 = if results[1] then results[1][:results] else [] end
            r1.zip(r2).each_with_index do |(s1, s2), i|
              s2 ||= {}
              csv << [*s1.values_at('timestamp', 'value'), s2['value']].compact
            end
          end

          "#{csv_headers}#{body}"
        end
      end
    end

    get '/groups/:group/:from/:to' do
      @from = params[:from]
      @to = params[:to]
      @interval = params.fetch('interval', '1h')
      @group = params[:group]
      @signal_array = groups[db_signal(@group)]

      error 404, {:status => 'Group not found'}.to_json if @signal_array.nil?

      respond_to do |wants|
        headers 'Vary' => 'Accept'

        wants.html do
          @title = I18n.t("groups.#{@group.gsub('-', '_')}")
          erb :group, layout: :default
        end

        wants.json do
          headers 'Access-Control-Allow-Origin' => '*'

          {
            signals: get_results
          }.to_json
        end

        wants.csv do
          headers 'Access-Control-Allow-Origin' => '*'

          csv_headers = @signal_array.dup.unshift('timestamp')

          results = get_results

          lines = results[0][:results].dup.map do |r|
            [
              r['timestamp'].to_s
            ]
          end

          results.each do |result|
            result[:results].each_with_index do |r, i|
              lines[i] << r['value']
            end
          end

          lines.unshift(csv_headers)

          CSV.generate do |csv|
            lines.each { |l| csv << l }
          end
        end
      end
    end

    get '/dashboards/:dashboard/:from/:to' do
      @dashboard = params[:dashboard]
      @title = I18n.t("groups.#{db_signal @dashboard}") + " Dashboard"
      @from = params[:from]
      @to = params[:to]
      @interval = params[:interval]

      respond_to do |wants|
        headers 'Vary' => 'Accept'

        wants.json do
          sigs = groups[db_signal @dashboard].map do |s|
            {name: I18n.t(s), url: "#{request.scheme}://#{request.env['HTTP_HOST']}/signals/#{web_signal s}"}
          end

          {signals: sigs}.to_json
        end
        wants.html do
          erb :dashboards, layout: :default
        end
      end
    end

    post '/:type/:signal' do
      params.delete_if { |k,v| v == '' }

      from = params.fetch('from', default_dates[:from])
      to = params.fetch('to', default_dates[:to])

      params['from'] = DateTime.parse(from).to_s
      params['to'] = DateTime.parse(to).to_s

      params['signal'] = params[:signal].split(',').first
      signals = params.values_at(:signal, :compare).compact.join(',')
      params['signal'] = web_signal(signals)

      @params = params
      @type = get_type

      redirect_to_signal
    end

    get '/stations' do
      @title = 'Choose a station'
      @stations = YAML.load_file File.join('config', 'stations.yml')
      erb :stations, layout: :default
    end

    post '/heatmap' do
      redirect to "/heatmap/#{DateTime.parse(params[:to]).to_s}"
    end

    get '/heatmap/?:from?/?:to?' do
      if !params[:from]
        hour = Time.now.hour
        minute = Time.now.min
        @date = "#{DEFAULT_DATE}T#{hour}:#{minute}:00"
      else
        @date = params[:from]
      end

      if params[:to]
        @period = true
        @to = params[:to]
        @from = params[:from]
      end

      respond_to do |wants|
        headers 'Vary' => 'Accept'

        wants.json do
          heatmap(@date).to_json
        end

        wants.html do
          @title = 'Heatmap'
          erb :heatmap, layout: :default
        end
      end
    end

    get '/:type/:signal' do
      params['from'] = default_dates[:from]
      params['to'] = default_dates[:to]
      @params = params
      @type = get_type

      redirect_to_signal
    end

    post '/stations/arriving/:direction/:station' do
      redirect to "/stations/arriving/#{params[:direction]}/#{params[:station]}/#{DateTime.parse(params[:to]).to_s}"
    end

    get '/stations/arriving/:direction/:station/?:to?' do
      @direction = params[:direction]
      @station = params[:station]

      if params[:to]
        @to = Time.parse(params[:to])
      else
        @reload_interval = '30'
        hour = Time.now.hour
        minute = Time.now.min
        @to = Time.parse("#{DEFAULT_DATE}T#{hour}:#{minute}:00")
      end

      respond_to do |wants|
        headers 'Vary' => 'Accept'

        wants.html do
          @title = 'Arriving trains'
          @next_trains = NextTrains.new(db_signal(@station), @direction.to_sym).results
          erb :arrivals, layout: :default
        end

        wants.json do
          Blocktrain::StationCrowding.new(@to,
            db_signal(@station), @direction.to_sym).results.to_json
        end
      end
    end

    get '/cromulent-dates' do
      cromulent_dates
    end

    # start the server if ruby file executed directly
    run! if app_file == $0
  end

end
