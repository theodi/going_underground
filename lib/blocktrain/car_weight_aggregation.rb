module Blocktrain
  class CarWeightAggregation

    def initialize(options = {})
      @lookups = Lookups.instance.lookups
      @car = options[:car]

      @from = parse_datetime(options.fetch(:from, '2015-09-01T00:00:00'))
      @to = parse_datetime(options.fetch(:to, '2015-09-02T00:00:00'))

      @interval = options.fetch(:interval, '10m')
    end

    def results
      Client.results(body)['aggregations']
    end

    def parse_datetime(datetime)
      utc = Time.parse(datetime).utc
      return utc.to_i * 1000
    end

    def address_query
      if @car.nil?
        @lookups['car_codes'].map { |car, code| "memoryAddress:#{code}" }.join(' OR ')
      else
        "memoryAddress:#{@lookups['car_codes'][@car]}"
      end
    end

    def query
      {
        filtered: {
          query: {
            query_string: {
              analyze_wildcard: true,
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

    def body
      {
        query: query,
        size: 0,
        aggregations: aggs,
      }
    end
  end
end
