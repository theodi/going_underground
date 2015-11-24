module SirHandel
  module Helpers
    def protected!
      return if ENV['RACK_ENV'] == 'test'
      return if authorized?
      headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
      halt 401, "Not authorized\n"
    end

    def env
      request.env
    end

    def authorized?
      @auth ||= Rack::Auth::Basic::Request.new(env)
      @auth.provided? and
        @auth.basic? and
        @auth.credentials and
        @auth.credentials == [
          ENV['TUBE_USERNAME'],
          ENV['TUBE_PASSWORD']
        ]
    end

    def check_dates
      invalid = []

      from = DateTime.parse(@from) rescue invalid << "'#{@from}' is not a valid ISO8601 date/time."
      to = DateTime.parse(@to) rescue invalid << "'#{@to}' is not a valid ISO8601 date/time."

      if invalid.count == 0
        invalid << "'from' date must be before 'to' date." if from > to
      end

      error_400(invalid.join(" ")) unless invalid.count == 0
    end

    def error_400(message)
      error 400, {:status => message}.to_json
    end

    def cromulent_dates
      redis.get('cromulent-dates') || SirHandel::Tasks.cromulise
    end

    def default_dates
      dates = JSON.parse(cromulent_dates)

      from = round_up(DateTime.parse(dates["start"]))
      to = from + 1
      {
        from: from.to_s,
        to: to.to_s
      }
    end

    def round_up(date)
      if date.hour != 0
        # Go to next day and round down to midnight
        date = date.next_day.to_date
        date.to_datetime
      else
        date
      end
    end

    def redis
      @redis ||= Redis.new(url: ENV['REDIS_URL'])
      @redis
    end

    def search
      check_dates

      search = {
        from: @from,
        to: @to,
        interval: @interval,
        signals: SirHandel::parameterize_signal(@signal)
      }

      r = Blocktrain::Aggregations::AverageAggregation.new(search).results

      results = r['results']['buckets'].map do |r|
        {
          'timestamp' => DateTime.strptime(r['key'].to_s, '%Q'),
          'value' => r['average_value']['value']
        }
      end

      {
        results: results
      }
    end

    def with_trend(search)
      search.merge(
        trend: Trend.new(search[:results], @from, @to).to_hash
      )
    end
  end
end
