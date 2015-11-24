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

      from = DateTime.parse(dates["start"])
      to = from + 1
      {
        from: from.to_s,
        to: to.to_s
      }
    end

    def redis
      @redis ||= Redis.new(url: ENV['REDIS_URL'])
      @redis
    end
  end
end
