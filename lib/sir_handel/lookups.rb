module Blocktrain
  class Lookups

    def fetch_from_redis
      redis = Redis.new(url: ENV['REDIS_URL'])

      lookups = redis.get('lookups') || Blocktrain::Lookups.instance.lookups.to_json
      aliases = redis.get('aliases') || Blocktrain::Lookups.instance.aliases.to_json

      @lookups = JSON.parse(lookups)
      @aliases = JSON.parse(aliases)
    end

  end
end
