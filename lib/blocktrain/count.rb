module Blocktrain
  class Count < Query

    def results
      result['count']
    end

    private

      def result
        Client.results(body, 'count')
      end

  end
end
