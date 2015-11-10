$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'blocktrain'
require_relative 'support/vcr_setup'

require 'coveralls'
Coveralls.wear!

begin
  require 'pry'
rescue LoadError
end

RSpec.configure do |config|
  config.after :each do
    Blocktrain::Lookups.instance.reset!
  end
end