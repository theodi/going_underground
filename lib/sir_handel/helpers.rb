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

    def get_type
      halt(404) unless ['signals', 'groups', 'dashboards'].include?(params[:type])
      params[:type]
    end

    def error_400(message)
      error 400, {:status => message}.to_json
    end

    def cromulent_dates
      dates = cached_dates
      if dates.nil?
        dates = redis.get('cromulent-dates') || SirHandel::Tasks.cromulise
        settings.cache.set('cromulent-dates', dates)
      end
      dates
    end

    def cached_dates
      settings.cache.get('cromulent-dates')
    end

    def default_dates
      dates = JSON.parse(cromulent_dates)

      from = round_up(DateTime.parse(dates["start"]))
      to = DateTime.new(from.year, from.month, from.day, 23, 59, 00, "+00:00")
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

    def group_path(group, format=nil)
      ["/groups/#{web_signal(group)}", format].compact.join('.')
    end

    def redirect_to_signal
      signal = @params.delete('signal')
      type = @params.delete('type')
      from = @params.delete('from')
      to = @params.delete('to')

      clean_params = {
        'layout' => @params['layout'],
        'interval' => @params['interval'],
      }.delete_if { |k,v| v.nil? }

      qs = clean_params.map { |k,v| "#{k}=#{v}" }.join('&')

      url = "/#{type}/#{signal}/#{from}/#{to}?#{qs}"

      redirect to(url)
    end

    def fake_network(time)
      from = Time.parse(time) - 2400
      to = Time.parse(time) + 2400
      trains = Blocktrain::Query.new(from: from.to_s, to: to.to_s, memory_addresses: ['2E5485AW'], sort: {'timeStamp' => 'desc'}).results

      @timestamp = nil

      # Get data two minutes apart to fake what we'd roughly see in real life
      trains.map! { |r|
        if @timestamp.nil? || @timestamp - Time.parse(r["_source"]["timeStamp"]) >= 120
          @timestamp = Time.parse(r["_source"]["timeStamp"])
          r
        end
      }.delete_if { |r| r.nil? }
    end

    def get_station(segment)
      direction = get_direction(segment)
      if direction == 'southbound'
        stations.to_a.select { |s| s.last[direction] < segment }.last.first rescue nil
      else
        stations.to_a.select { |s| s.last[direction] > segment }.first.first rescue nil
      end
    end

    def get_direction(segment)
      segment.even? ? 'northbound' : 'southbound'
    end

    def crowding_presenter(results)
      # Add stations, directions and total load
      results.each do |r|
        r.first['station'] = get_station(r.first['segment'])
        r.first['direction'] = get_direction(r.first['segment'])
        r.first['load'] = r.last.values.reduce(:+).to_f / r.last.size
      end

      # Group by station and direction
      grouped = results.group_by { |r| "#{r.first['station']}_#{r.first['direction']}" }

      # Average out load values
      grouped.map do |r|
        values = r.last.map { |r| r.first['load'] }
        {
          segment: r.last[0][0]['segment'],
          station: r.last[0][0]['station'],
          direction: r.last[0][0]['direction'],
          load: values.reduce(:+).to_f / values.size
        }
      end
    end

    def heatmap(date)
      # Get all trains on the line - faking this by getting all locations 40 minutes either side
      trains = fake_network(date)
      crowding = Blocktrain::TrainCrowding.new(trains).results
      crowding_presenter(crowding)
    end

    def date_step(from, to, step_in_minutes = 5)
      from = to_seconds(from)
      to = to_seconds(to)
      step = step_in_minutes * 60
      from.step(to,step).map { |s| DateTime.strptime(s.to_s,'%s') }
    end

    def to_seconds(date)
      date.to_time.to_i
    end

    def redis
      @redis ||= ConnectionPool::Wrapper.new(size: 5, timeout: 3) { Redis.new(url: ENV['REDIS_URL']) }
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

      if @interval.nil?
        search.merge!({sort: { timeStamp: 'asc' }})
        r = Blocktrain::Query.new(search).results
        return results_hash(signal, []) if r.nil?

        results = r.map do |r|
          result_hash(DateTime.parse(r['_source']['timeStamp']), r['_source']['value']) rescue nil
        end

        results_hash(signal, results)
      else
        r = Blocktrain::Aggregations::AverageAggregation.new(search).results
        return results_hash(signal, []) if r.nil?

        results = r['results']['buckets'].map do |r|
          result_hash(DateTime.strptime(r['key'].to_s, '%Q'), r['average_value']['value']) rescue nil
        end

        results_hash(signal, results)
      end
    end

    def result_hash(timestamp, value)
      {
        'timestamp' => timestamp,
        'value' => value
      }
    end

    def results_hash(signal, results)
      {
        name: I18n.t(db_signal(signal)),
        results: results
      }
    end

    def lookups
      load_yaml 'signal_aliases.yml'
    end

    def groups
      load_yaml 'signal_groups.yml'
    end

    def stations
      load_yaml  'stations.yml'
    end

    def load_yaml(filename)
      YAML.load_file File.join('config', filename)
    end

    def with_trend(search)
      search.merge(
        trend: Trend.new(search[:results], @from, @to).to_hash
      )
    end

    def get_results
      @signal_array.map do |s|
        with_trend(search(s))
      end
    end

    def signal_url(signals, from, to, interval, format)
      path = [signals, from, to].join('/')
      qs = interval.nil? ? "" : "?interval=#{interval}"
      "/signals/#{path}.#{format}#{qs}"
    end

  end
end
