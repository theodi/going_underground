module Blocktrain
  class PaginatedQuery

    def initialize(search)
      @search = search
      @search[:limit] ||= 100
      @search[:offset] ||= 0
      @results = []
      @count = Blocktrain::Count.new(@search).results
    end

    def run_query
      while @search[:offset] < @count
        require "pry"; binding.pry

        get_page
      end
    end

    def get_page
      @results << Blocktrain::Query.new(@search).results
      @search[:offset] = @search[:offset] + @search[:limit]
    end

    def results
      run_query
      @results.flatten!
    end

  end
end
