require_relative 'support/vcr_setup'

# Comment out when recording new VCR cassettes
ENV['ES_URL'] = 'http://elastic.search/'

RSpec.configure do |config|
  config.after :each do
    Blocktrain::Lookups.instance.reset!
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.order = :random
end
