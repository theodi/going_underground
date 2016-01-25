module Blocktrain
  class NetworkQuery
    def initialize(options = {})
      @datetime = options.fetch(:datetime)
      @signal = options.fetch(:signal)
      @interval = options.fetch(:interval, '2m')

      @from = Time.parse(@datetime) - 1800
      @to = Time.parse(@datetime) + 1800
    end

    def aggregation
      Blocktrain::Aggregations::MinMaxAggregation.new(from: @from.to_s, to: @to.to_s, memory_addresses: [@signal], interval: @interval, sort: {'timeStamp' => 'desc'})
    end

    def results
      aggregation.results['results']['buckets'].map do |r|
        {
          'timestamp' => r['key_as_string'],
          'value' => r['value']['buckets'].first['max_value']['value']
        }
      end
    end


  end
end
