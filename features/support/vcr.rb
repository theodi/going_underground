require 'vcr'
require 'webmock/cucumber'

VCR.configure do |c|
  if ENV['VCR_RECORD'] == 'yes'
    c.default_cassette_options = { :record => :once }
  else
    c.default_cassette_options = { :record => :none }
  end
  c.cassette_library_dir = 'fixtures/cucumber/vcr'
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = true
end

VCR.cucumber_tags do |t|
  t.tag '@vcr', use_scenario_name: true
end
