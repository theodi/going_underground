module Blocktrain
  class Query

    def initialize(options = {})
      @lookups = Lookups.instance.lookups
      @signal = options[:signal]
      @sub_signal = options[:sub_signal]

      @from = parse_datetime(options.fetch(:from, '2015-09-01T00:00:00'))
      @to = parse_datetime(options.fetch(:to, '2015-09-02T00:00:00'))
    end

    def results
      result['hits']['hits']
    end

    def parse_datetime(datetime)
      utc = Time.parse(datetime).utc
      return utc.to_i * 1000
    end

    def address_query
      if @lookups[@signal].is_a?(Hash)
        if @sub_signal.nil?
          @lookups[@signal].map { |k, v| "memoryAddress:#{v}" }.join(' OR ')
        else
          "memoryAddress:#{@lookups[@signal][@sub_signal]}"
        end
      else
        "memoryAddress:#{@lookups[@signal]}"
      end
    end

    def query
      {
        filtered: {
          query: {
            query_string: {
              query: address_query
            }
          },
          filter: {
            bool: {
              must: [
                {
                  range: {
                    timeStamp: {
                      gte: @from,
                      lte: @to
                    }
                  }
                }
              ]
            }
          }
        }
      }
    end

    def body
      {
        query: query
      }
    end

    private

      def result
        Client.results(body)
      end

  end
end
