module Blocktrain
  module Aggregations
    class CarWeightAggregation < Aggregation

      def aggs
        {
          weight_chart: {
            date_histogram: {
              field: 'timeStamp',
              interval: @interval,
              pre_zone: '+01:00',
              pre_zone_adjust_large_interval: true,
              min_doc_count: 1,
              extended_bounds: {
                min: @from,
                max: @to
              }
            },
            aggregations: car_weight_aggs
          }
        }
      end

      def car_weight_aggs
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
end
