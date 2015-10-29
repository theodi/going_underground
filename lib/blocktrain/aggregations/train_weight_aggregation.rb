module Blocktrain
  module Aggregations
    class TrainWeightAggregation < Aggregation

      def local_aggregations
        {
          weight: {
            avg: {
              field: 'value'
            }
          }
        }
      end
    end
  end
end
