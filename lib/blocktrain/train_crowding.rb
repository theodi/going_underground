module Blocktrain
  class TrainCrowding
    CAR_LOADS = %w[2e64930w 2e64932w 2e64934w 2e64936w]
    CAR_NAMES = %w[CAR_A CAR_B CAR_C CAR_D]

    def initialize(results)
      @results = results
    end

    def results
      @results.map do |location|
        train = {
          'segment' => location['_source']['value'],
          'number' => location['_source']['trainNumber'],
          'timeStamp' => location['_source']['timeStamp']
        }
        time = Time.parse(train['timeStamp'])
        [train, crowd_results(time, train)]
      end
    end

    def crowd_results time, train = nil
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
  end
end
