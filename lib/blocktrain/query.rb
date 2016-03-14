module Blocktrain
  class Query

    def initialize(options = {})
      @memory_addresses = [options.fetch(:memory_addresses, nil)].flatten.compact

      @original_from = options.fetch(:from, '2015-09-01T00:00:00')
      @original_to = options.fetch(:to, '2015-09-02T00:00:00')

      @from = parse_datetime(@original_from)
      @to = parse_datetime(@original_to)

      @limit = options.fetch(:limit, nil)
      @offset = options.fetch(:offset, 0)

      @sort = options.fetch(:sort, {})
    end

    def index_name
      from = Date.parse(@original_from)
      to = Date.parse(@original_to)
      if from == to
        y, m, d = from.strftime("%Y"), from.strftime("%-m"), from.strftime("%-e")
        "train_data_#{y}_#{m}_#{d}"
      else
        raise RuntimeError.new("Queries can only span one day")
      end
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
        size: limit,
        sort: @sort,
        from: @offset
      }
    end

    def limit
      if @limit.nil?
        Blocktrain::Count.new({from: @original_from, to: @original_to, memory_addresses: @memory_addresses, sort: @sort}).results
      else
        @limit
      end
    end

    private

      def result
        Client.results(body)
      end

  end
end
