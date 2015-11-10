require 'spec_helper'
require 'rack/test'

require File.expand_path '../../lib/sir_handel/app.rb', __FILE__

ENV['RACK_ENV'] = 'test'

module RSpecMixin
  include Rack::Test::Methods
  def app() SirHandel::App end
end

# For RSpec 2.x
RSpec.configure { |c| c.include RSpecMixin }

describe "SirHandel::App", :vcr do

  it "should allow accessing the home page" do
    get '/'
    expect(last_response).to be_ok
  end

  it "should return some default data" do
    get '/weight.json'

    json = JSON.parse(last_response.body)

    expect(json["results"].first).to eq({
      "timestamp"=>"2015-09-01T00:00:00+00:00",
      "value"=>0.0
    })

    expect(json["results"].last).to eq({
      "timestamp"=>"2015-09-01T23:00:00+00:00",
      "value"=>5308.094351083215
    })
  end

  it "should allow the date to be specified" do
    get '/weight.json', from: "2015-09-23 00:00:00Z", to: "2015-09-24 00:00:00Z"

    json = JSON.parse(last_response.body)

    expect(json["results"].first["timestamp"]).to eq("2015-09-23T04:00:00+00:00")
  end

  it "should allow the interval to be specified" do
    expect(Blocktrain::Aggregations::AverageAggregation).to receive(:new).with(hash_including(interval: "1h")).and_call_original
    get '/weight.json', interval: "1h"
  end

end
