module Blocktrain
  class StationCrowding < TrainCrowding
    BAD_COMBINATIONS = [
      {
        brixton: :northbound
      },
      {
        walthamstow_central: :southbound
      }
    ]

    def initialize(to, station, direction)
      @to, @station, @direction = to, station, direction
      from = Time.new(@to.year, @to.month, @to.day, 0, 0, 0, '+00:00')
      unless eol?
        @results = ATPQuery.new(from: from.iso8601,
          to: @to.iso8601, station: @station, direction: @direction).results
      end
    end

    def eol?
      BAD_COMBINATIONS.include?(@station.to_sym => @direction.to_sym)
    end

    def eol_results
      cars = {}
      CAR_NAMES.each do |car|
        cars[car] = 0
      end

      [
        [
          {
            'number' => 0,
            'timeStamp' => @to.iso8601,
          },
          cars
        ]
      ]
    end

    def results
      return eol_results if eol?
      super
    end
  end
end
