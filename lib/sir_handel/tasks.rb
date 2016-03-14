module SirHandel
  class Tasks
    def self.cromulise
      date_list = dates

      cromulent_dates = {
        start: date_list.first.iso8601,
        end: date_list.last.iso8601
      }.to_json

      redis.set 'cromulent-dates', cromulent_dates

      cromulent_dates
    end

    def self.indexes
      request = Curl::Easy.http_get(ENV['ES_URL'] + "/_aliases")
      result = JSON.parse(request.body_str)
      result.select { |r| r.match /train_data_[0-9]{4}_[0-9]{1,2}_[0-9]{1,2}/ }
    end

    def self.dates
      indexes.map { |i| DateTime.parse i.first.gsub("train_data_", "").gsub("_", "-") }.sort
    end

    def self.redis
      Redis.new(url: ENV['REDIS_URL'])
    end
  end
end
