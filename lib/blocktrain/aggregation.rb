module Blocktrain
  class Aggregation

    CAR_CODES = {
      'A' => '2E64930W',
      'B' => '2E64932W',
      'C' => '2E64934W',
      'D' => '2E64936W'
    }

    def initialize(options = {})
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
        CAR_CODES.map { |code| "memoryAddress:#{code}" }.join(' OR ')
      else
        "memoryAddress:#{CAR_CODES[@car]}"
      end
    end

    def query
      {
        filtered:  {
          query:  {
            query_string:  {
              analyze_wildcard: true,
              query: address_query
            }
          },
          filter:  {
            bool:  {
              must:  [
                {
                  range:  {
                    timeStamp:  {
                      gte: @from,
                      lte: @to
                    }
                  }
                }
              ],
              must_not:  []
            }
          }
        }
      }
    end

    def aggs
      {
         weight_chart:  {
           date_histogram:  {
             field:  'timeStamp',
             interval:  @interval,
             pre_zone:  '+01:00',
             pre_zone_adjust_large_interval: true,
             min_doc_count:  1,
             extended_bounds:  {
               min: @from,
               max: @to
             }
          },
          aggregations:  {
            weight:  {
              avg:  {
                field:  'value'
              }
            }
          }
        },
      }
    end

    def body
      {
        query:  query,
        size: 0,
        'aggregations' => aggs,
      }
    end
  end
end
