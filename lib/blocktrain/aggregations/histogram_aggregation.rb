module Blocktrain
  module Aggregations
    class HistogramAggregation < Aggregation

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

    end
  end
end
