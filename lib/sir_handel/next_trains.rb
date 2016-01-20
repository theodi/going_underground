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
      json.map { |result|
        (result['timeToStation'].to_f / 60).round
      }.sort
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
