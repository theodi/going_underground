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
    set :raise_errors, ['cucumber', 'test'].include?(ENV['RACK_ENV'])

    set :default_interval, '10m'

    get '/' do
      redirect to('/signals')
    end

    get '/signals' do
      protected!

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
      protected!

      @from = params[:from]
      @to = params[:to]
      @signals = params['signals']
      @interval = params.fetch('interval', '1h')

      @signal_array = @signals.split(',')

      error_400('Please set a maximum of two signals') if @signal_array.count > 2

      respond_to do |wants|
        headers 'Vary' => 'Accept'

        wants.html do
          @signal_list = lookups

          signals = @signal_array.map { |s| I18n.t(s.gsub '-', '_') }
          @title = signals.join(' compared with ')
          erb :signal, layout: :default
        end

        wants.json do
          headers 'Access-Control-Allow-Origin' => '*'

          {
            signals: get_results
          }.to_json
        end

        wants.csv do
          headers 'Access-Control-Allow-Origin' => '*'

          csv_headers = @signal_array.dup.unshift('timestamp').to_csv
          results = get_results

          body = CSV.generate do |csv|
            results[0][:results].each_with_index do |result, i|
              line = [result['timestamp'].to_s, result['value']]
              line << results[1][:results][i]['value'] if results[1]
              csv << line
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

    post '/:type/:signal' do
      params.delete_if { |k,v| v == '' }

      from = params.fetch('from', default_dates[:from])
      to = params.fetch('to', default_dates[:to])
      interval = params.fetch('interval', settings.default_interval)
      type = get_type

      params[:signal] = params[:signal].split(',').first

      signal = [
        params[:signal],
        params[:compare]
      ].delete_if { |s| s.nil? }.join(',')

      from = DateTime.parse(from).to_s
      to = DateTime.parse(to).to_s

      redirect to("/#{type}/#{web_signal(signal)}/#{from}/#{to}?interval=#{interval}")
    end

    get '/:type/:signal' do
      signal = params['signal']
      type = params['type']
      interval = params.fetch('interval', settings.default_interval)
      type = get_type

      redirect to("/#{type}/#{signal}/#{default_dates[:from]}/#{default_dates[:to]}?interval=#{interval}")
    end

    get '/cromulent-dates' do
      cromulent_dates
    end

    # start the server if ruby file executed directly
    run! if app_file == $0
  end

end
