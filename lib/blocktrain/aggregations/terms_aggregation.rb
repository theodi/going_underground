module Blocktrain
  module Aggregations
    class TermsAggregation < Aggregation

      def initialize(options = {})
        @term = options.fetch(:term, nil)
        raise ArgumentError.new("TermAggregation requires a term: argument") unless @term
        super
      end

      def query
        {
          filtered: {
            filter: filtered_filter
          }
        }
      end

      def aggs
        {
          langs: {
            terms: {
              field: @term,
              size: 0
            }
          }
        }
      end

      def results
        result['aggregations']['langs']['buckets']
      end

    end
  end
end
