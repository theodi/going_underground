module Blocktrain
  class TrainCrowding
    CAR_LOADS = %w[2E64930W 2E64932W 2E64934W 2E64936W]
    CAR_NAMES = %w[CAR_A CAR_B CAR_C CAR_D]

    def initialize(from, to)
      @atp_query = ATPQuery.new(from: from, to: to)
    end

    def results
      @atp_query.results.map do |location|
        time = Time.parse(location['_source']['timeStamp'])
        from, to = time - 60, time + 60
        load_query = Aggregations::MultiValueAggregation.new(from: from.iso8601, to: to.iso8601, memory_addresses: CAR_LOADS)
        [location['_source'], load_query]
      end
    end

    def output
      results.each do |location, crowd_info|
        crowd = crowd_info.results
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
