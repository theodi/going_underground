require 'sinatra/base'
require_relative './client'

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

      r = Client.new(from: params[:from], to: params[:to], car: params[:car], interval: params[:interval]).results

      results = r["aggregations"]["2"]["buckets"].map do |r|
        {
          "timestamp" => DateTime.strptime((r["key"] + 3600000).to_s, "%Q"),
          "value" => r["1"]["value"]
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
