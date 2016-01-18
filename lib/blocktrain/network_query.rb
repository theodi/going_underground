module Blocktrain
  class NetworkQuery
    def initialize(options = {})
      @datetime = options.fetch(:datetime)
      @signal = options.fetch(:signal)
      @interval = options.fetch(:interval, '2m')

      @from = Time.parse(@datetime) - 1800
      @to = Time.parse(@datetime) + 1800
    end

    def results
      Blocktrain::Aggregations::MinMaxAggregation.new(from: @from.to_s, to: @to.to_s, memory_addresses: [@signal], interval: @interval, sort: {'timeStamp' => 'desc'}).results
    end
  end
end
