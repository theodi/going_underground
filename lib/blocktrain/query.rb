module Blocktrain
  class Query

    def initialize(options = {})
      @memory_addresses = [options.fetch(:memory_addresses, nil)].flatten.compact

      @from = parse_datetime(options.fetch(:from, '2015-09-01T00:00:00'))
      @to = parse_datetime(options.fetch(:to, '2015-09-02T00:00:00'))

      @limit = options.fetch(:limit, 100)
      @offset = options.fetch(:offset, 0)

      @sort = options.fetch(:sort, {})
    end

    def results
      result['hits']['hits']
    end

    def hits
      result['hits']['total']
    end

    def parse_datetime(datetime)
      utc = Time.parse(datetime).utc
      return utc.to_i * 1000
    end

    def address_query
      return nil if @memory_addresses == []
      build_query(@memory_addresses)
    end

    def build_query(addresses)
      terms = addresses.map { |a| "memoryAddress:#{a}" }
      terms.join(" OR ")
    end

    def query
      {
        filtered: {
          query: filtered_query,
          filter: filtered_filter
        }
      }
    end

    def filtered_query
      q = address_query
      return {} if q.nil?
      {
        query_string: {
          query: q
        }
      }
    end

    def filtered_filter
      {
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
    end

    def body
      {
        query: query,
        size: @limit,
        sort: @sort,
        from: @offset
      }
    end

    private

      def result
        Client.results(body)
      end

  end
end
