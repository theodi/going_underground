module Blocktrain
  class TrainWeightAggregation < Aggregation

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
          aggregations: {
            weight: {
              avg: {
                field: 'value'
              }
            }
          }
        }
      }
    end
  end
end
