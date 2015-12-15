module Blocktrain
  module Aggregations
    class MultiValueAggregation < AverageAggregation

      def aggs
        filters = @memory_addresses.map do |mem_addr|
          [mem_addr, { term: { memoryAddress: mem_addr } }]
        end

        histogram = super
        {
          results: {
            filters: {
              filters: filters.to_h
            },
            aggregations: histogram
          }
        }
      end

    end
  end
end

