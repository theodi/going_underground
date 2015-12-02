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

    def web_signal(signal)
      signal.gsub('_', '-')
    end

    def db_signal(signal)
      signal.gsub('-', '_')
    end

    def signal_path(signal, format=nil)
      ["/signals/#{web_signal(signal)}", format].compact.join('.')
    end

    def redis
      @redis ||= Redis.new(url: ENV['REDIS_URL'])
      @redis
    end

    def search(signal)
      check_dates

      search = {
        from: @from,
        to: @to,
        interval: @interval,
        memory_addresses: lookups[db_signal(signal)].upcase
      }

      r = Blocktrain::Aggregations::AverageAggregation.new(search).results

      if r.nil?
        results = []
      else
        results = r['results']['buckets'].map do |r|
          {
            'timestamp' => DateTime.strptime(r['key'].to_s, '%Q'),
            'value' => r['average_value']['value']
          } rescue nil
        end
      end

      {
        name: I18n.t(signal.gsub '-', '_'),
        results: results
      }
    end

    def lookups
      load_yaml 'signal_aliases.yml'
    end

    def groups
      load_yaml 'signal_groups.yml'
    end

    def load_yaml(filename)
      YAML.load_file File.join('config', filename)
    end

    def with_trend(search)
      if search[:results] == []
        return search
      else
        return search.merge(
          trend: Trend.new(search[:results], @from, @to).to_hash
        )
      end
    end

    def get_results
      @signal_array.map do |s|
        with_trend(search s)
      end
    end
  end
end
