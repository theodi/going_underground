module Blocktrain
  module Aggregations
    class AverageAggregation < HistogramAggregation

      def local_aggregations
        {
          average_value: {
            avg: {
              field: 'value'
            }
          }
        }
      end

    end
  end
end
