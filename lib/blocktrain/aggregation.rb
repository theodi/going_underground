module Blocktrain
  class Aggregation < Query
    def initialize(options = {})
      @interval = options.fetch(:interval, '10m')
      super
    end

    def results
      result['aggregations']
    end

    def aggs
      raise RuntimeError.new("Aggregation cannot be used directly. Use a derived class instead like AverageAggregation.")
    end

    def body
      {
        query: query,
        size: 0,
        aggregations: aggs,
      }
    end
    
  end
end
