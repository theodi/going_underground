$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'blocktrain'
require_relative 'support/vcr_setup'

require 'coveralls'
Coveralls.wear!
