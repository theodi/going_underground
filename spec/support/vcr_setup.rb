require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/support/vcr'
  c.hook_into :webmock
  c.default_cassette_options = { :record => :once }
  c.allow_http_connections_when_no_cassette = true

  c.filter_sensitive_data('http://elastic.search/') { ENV['ES_URL'] }
  c.filter_sensitive_data('http://elastic.search/') { u = URI(ENV['ES_URL']); u.userinfo = ''; u.to_s }

  c.configure_rspec_metadata!
end
