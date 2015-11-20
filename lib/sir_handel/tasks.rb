module SirHandel
  class Tasks
    def self.cromulise
      search = {
        from: '2015-01-01T00:00:00+00:00',
        to: '2016-01-01T00:00:00+00:00',
        interval: '1h',
        signals: 'line_current'
      }

      r = Blocktrain::Aggregations::AverageAggregation.new(search).results

      cromulent_dates = {
        start: Time.parse(r['results']['buckets'].first['key_as_string']).utc.to_datetime.iso8601,
        end: Time.parse(r['results']['buckets'].last['key_as_string']).utc.to_datetime.iso8601
      }.to_json

      redis = Redis.new(url: ENV['REDIS_URL'])
      redis.set 'cromulent-dates', cromulent_dates

      cromulent_dates
    end
  end
end
