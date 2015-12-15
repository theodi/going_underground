require 'rubygems'
require 'bundler'
Bundler.require

Dotenv.load

require_relative 'lib/blocktrain'

tc = Blocktrain::TrainCrowding.new("2015-08-28T06:30:00Z", "2015-08-28T08:00:00Z")

tc.output

exit
