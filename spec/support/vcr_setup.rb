require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/rspec/vcr'
  c.hook_into :webmock
  if ENV['VCR_RECORD'] == 'yes'
    c.default_cassette_options = { :record => :all }
  else
    c.default_cassette_options = { :record => :none }
  end
  c.allow_http_connections_when_no_cassette = false

  c.filter_sensitive_data('http://elastic.search/') { ENV['ES_URL'] }
  c.filter_sensitive_data('http://elastic.search/') { u = URI(ENV['ES_URL']); u.userinfo = ''; u.to_s }

  c.configure_rspec_metadata!
end
