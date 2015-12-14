module Blocktrain
  class PaginatedQuery

    def initialize(search)
      @search = search
      @count = Blocktrain::Count.new(@search).results
      @search[:limit] ||= @count
      @search[:offset] ||= 0
      @results = []
    end

    def run_query
      while @search[:offset] < @count
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
