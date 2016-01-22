module SirHandel
  class NextTrains

    def initialize(station, direction)
      @station = naptan(station)
      @direction = direction(direction)
    end

    def url
      "https://api.tfl.gov.uk/line/victoria/arrivals?stopPointId=#{@station}&direction=#{@direction}"
    end

    def json
      r = Curl::Easy.http_get(url)
      JSON.parse(r.body)
    end

    def results
      sorted_results.map { |result|
        format_time(result['timeToStation'])
      }
    end

    def sorted_results
      json.sort_by { |r| r['timeToStation'] }
    end

    def format_time(timetostation)
      timetostation > 60 ? "Arriving in #{round_to_minutes(timetostation)} minutes" : "less than a minute"
    end

    def round_to_minutes(timetostation)
      (timetostation.to_f / 60).round
    end

    def naptan(station)
      stations[station]['naptan']
    end

    def direction(dir)
      {
        northbound: 'inbound',
        southbound: 'outbound',
      }[dir]
    end

    def stations
      YAML.load_file File.join('config', 'stations.yml')
    end

  end
end
