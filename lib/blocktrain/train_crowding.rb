module Blocktrain
  class TrainCrowding
    CAR_LOADS = %w[2E64930W 2E64932W 2E64934W 2E64936W]

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
  end
end
