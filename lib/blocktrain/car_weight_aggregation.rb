module Blocktrain
  class CarWeightAggregation < Aggregation

    def aggs
      {
        weight: {
          terms: { field: 'memoryAddress' },
          aggregations: {
            avg_weight: {
              avg: {
                field: 'value'
              }
            },
            max_weight: {
              max: {
                field: 'value'
              }
            },
            min_weight: {
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
