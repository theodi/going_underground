require 'curb'
require 'dotenv'
require 'yaml'
require 'json'
require 'date'
require 'singleton'

require 'blocktrain/version'
require 'blocktrain/client'
require 'blocktrain/lookups'
require 'blocktrain/aggregation'
require 'blocktrain/aggregations/train_weight_aggregation'
require 'blocktrain/aggregations/car_weight_aggregation'

Dotenv.load
