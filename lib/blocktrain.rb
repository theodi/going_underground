require 'curb'
require 'dotenv'
require 'yaml'
require 'json'
require 'date'
require 'singleton'

require 'blocktrain/version'
require 'blocktrain/client'
require 'blocktrain/lookups'
require 'blocktrain/train_weight_aggregation'
require 'blocktrain/car_weight_aggregation'

Dotenv.load
