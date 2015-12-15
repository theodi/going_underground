module Blocktrain
  class TrainCrowding
    CAR_LOADS = %w[2E64930W 2E64932W 2E64934W 2E64936W]
    CAR_NAMES = %w[CAR_A CAR_B CAR_C CAR_D]

    def initialize(to, station, direction)
      from = to - 7200
      @atp_query = ATPQuery.new(from: from.iso8601,
        to: to.iso8601, station: station, direction: direction)
    end

    def results
      @atp_query.results.map do |location|
        train = {
          'number' => location['_source']['trainNumber'],
          'timeStamp' => location['_source']['timeStamp']
        }
        time = Time.parse(train['timeStamp'])
        [train, crowd_results(time, train)]
      end
    end

    def crowd_results(time, train)
      from, to = time - 60, time + 60
      crowd_query = Aggregations::MultiValueAggregation.new(
        from: from.iso8601, to: to.iso8601, memory_addresses: CAR_LOADS)
      crowd_query.results['results']['buckets'].map do |car_mem_addr, v|
        res = v['results']['buckets'][0]
        [
          CAR_NAMES[CAR_LOADS.index(car_mem_addr)],
          (res ? res['average_value']['value'] : 0)
        ]
      end.to_h
    end

    def output
      results.each do |location, crowd|
        info = crowd['results']['buckets'].map do |car_mem_addr, bucket|
          name = CAR_NAMES[CAR_LOADS.index(car_mem_addr)]
          full = bucket['results']['buckets'][0]['average_value']['value'] rescue nil
          [name, "%.2f" % full.to_f]
        end
        puts [
          location['timeStamp'].ljust(25),
          location['value'],
          *info
        ].join("\t")
      end
      nil
    end
  end
end
