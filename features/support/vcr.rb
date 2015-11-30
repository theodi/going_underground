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
  c.allow_http_connections_when_no_cassette = false

  c.filter_sensitive_data('http://elastic.search') { ENV['ES_URL'] }
  c.filter_sensitive_data('http://elastic.search') { u = URI(ENV['ES_URL']); u.userinfo = ''; u.to_s }
end

VCR.cucumber_tags do |t|
  t.tag '@vcr', use_scenario_name: true
end
