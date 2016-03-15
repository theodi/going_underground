module Blocktrain
  class Count < Query

    def results
      result['count']
    end

    def limit
      0
    end

    private

      def result
        Client.results(body, 'count', index_name)
      end

  end
end
