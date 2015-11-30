module Blocktrain
  class Lookups
    include Singleton

    def lookups
      init! if @lookups.nil?
      @lookups
    end

    def aliases
      init! if @aliases.nil?
      @aliases
    end

    def reset!
      @lookups = nil
      @aliases = nil
    end

    # Separate out initialization for testing purposes
    def init!
      @aliases ||= {}
      # Get unique list of keys from ES
      r = Aggregations::TermsAggregation.new(from: '2015-09-01 00:00:00Z', to: '2015-09-02 00:00:00Z', term: "signalName").results
      signals = r.map {|x| x["key"]}
      aliases = OpenStruct.new fetch_yaml 'signal_aliases'
      aliases.each_pair do |key, value|
        @aliases[key.to_s] = signals[value]
      end
    end

    def fetch_from_redis
      redis = Redis.new(url: ENV['REDIS_URL'])

      @lookups = JSON.parse(redis.get('lookups') || lookups.to_json)
      @aliases = JSON.parse(redis.get('aliases') || aliases.to_json)
    end

    private

    def fetch_yaml file
      YAML.load(File.open(File.join(File.dirname(__FILE__), '..', '..', 'config/%s.yml' % file)))
    end

    # This will go away once we get the correct signals in the DB
    def remove_cruft(signal)
      parts = signal.split(".")
      [
        parts[0..-3].join('.'),
        parts.pop
      ].join('.')
    end

  end
end
