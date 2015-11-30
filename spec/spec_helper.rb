if ENV['COVERAGE']
  require 'coveralls'
  Coveralls.wear_merged!
end

ENV['RACK_ENV'] = 'test'
# Comment out when recording new VCR cassettes
unless ENV['VCR_RECORD'] == 'yes'
  ENV['ES_URL'] = 'http://elastic.search/'
end

require 'rack/test'
require 'nokogiri'
require_relative 'support/vcr_setup'

require File.expand_path '../../lib/sir_handel.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods
  def app() SirHandel::App end
end

module SirHandel
  class TestHelpers
    include SirHandel::Helpers
  end
end

RSpec.configure do |config|
  config.include RSpecMixin

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.order = :random
end
