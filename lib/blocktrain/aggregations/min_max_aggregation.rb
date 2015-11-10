module Blocktrain
  module Aggregations
    class MinMaxAggregation < Aggregation

      def local_aggregations
        {
          value: {
            terms: { field: 'memoryAddress' },
            aggregations: {
              average_value: {
                avg: {
                  field: 'value'
                }
              },
              max_value: {
                max: {
                  field: 'value'
                }
              },
              min_value: {
                min: {
                  field: 'value'
                }
              }
            }
          }
        }
      end
    end
  end
end
