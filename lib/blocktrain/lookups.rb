module Blocktrain
  class Lookups
    include Singleton

    def lookups
      init! if @lookups.nil?
      @lookups
    end

    def reset!
      @lookups = nil
    end

    # Separate out initialization for testing purposes
    def init!
      @lookups ||= {}
      # Get unique list of keys from ES
      r = Aggregations::TermsAggregation.new(from: '2015-09-01 10:00:00Z', to: '2015-09-01 11:00:00Z', term: "memoryAddress").results
      addresses = r.map {|x| x["key"]}
      # Get a memory location for each key
      addresses.each do |address|
        r = Query.new(from: '2015-09-01 10:00:00Z', to: '2015-09-01 11:00:00Z', memory_address: address, limit: 1).results
        @lookups[r.first["_source"]["signalName"].to_s] = address
      end
      # Read aliases from file
      aliases = OpenStruct.new fetch_yaml 'signal_aliases'
      aliases.each_pair do |key, value|
        @lookups[key.to_s] = @lookups[value]
      end
    end

    private

    def fetch_yaml file
      YAML.load(File.open(File.join(File.dirname(__FILE__), '..', '..', 'config/%s.yml' % file)))
    end
  end
end
