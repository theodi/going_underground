require 'spec_helper'
require 'rack/test'

require File.expand_path '../../lib/tube_pi.rb', __FILE__

ENV['RACK_ENV'] = 'test'

module RSpecMixin
  include Rack::Test::Methods
  def app() TubePi end
end

# For RSpec 2.x
RSpec.configure { |c| c.include RSpecMixin }

describe "TubePi" do

  it "should allow accessing the home page" do
    get '/'
    expect(last_response).to be_ok
  end

  it "should return some default data" do
    get '/weight.json'

    json = JSON.parse(last_response.body)

    expect(json["results"].first).to eq({
      "timestamp"=>"2015-09-01T00:00:00+00:00",
      "value"=>8.450292397660819
    })

    expect(json["results"].last).to eq({
      "timestamp"=>"2015-09-01T23:50:00+00:00",
      "value"=>7.500754147812971
    })
  end

  it "should allow the date to be specified" do
    get '/weight.json', date: "23-09-2015"

    json = JSON.parse(last_response.body)

    expect(json["results"].first["timestamp"]).to eq("2015-09-23T00:00:00+00:00")
  end

  it "should allow the car to be specified" do
    expect(TubeClient).to receive(:new).with(date: nil, car: "A", interval: nil).and_call_original
    get '/weight.json', car: "A"
  end

  it "should allow the interval to be specified" do
    expect(TubeClient).to receive(:new).with(date: nil, car: nil, interval: "1h").and_call_original
    get '/weight.json', interval: "1h"
  end

end
