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
      {
        results: {
          date_histogram: {
            field: 'timeStamp',
            interval: @interval,
            time_zone: '+01:00',
            min_doc_count: 1,
            extended_bounds: {
              min: @from,
              max: @to
            }
          },
          aggregations: local_aggregations
        }
      }
    end

    def body
      {
        query: query,
        size: 0,
        aggregations: aggs,
      }
    end
    
    def local_aggregations
      raise RuntimeError.new("Aggregation cannot be used directly. Use a derived class instead like AverageAggregation.")
    end
    
  end
end
