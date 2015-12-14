module Blocktrain
  describe PaginatedQuery do

    let(:search) do
      {
        :from=>"2015-09-01T09:00:00",
        :to=>"2015-09-01T10:00:00",
        :memory_addresses=>"2E491EEW",
        :sort=>{
          :timeStamp=>"asc"
        }
      }
    end

    it 'gets the correct number of results', :vcr do
      count = Blocktrain::Count.new(search).results
      results = Blocktrain::PaginatedQuery.new(search).results

      expect(results.count).to eq(count)
    end

    it 'gets the correct results', :vcr do
      count = Blocktrain::Count.new(search).results
      full_search = Blocktrain::Query.new(search.merge(limit: count)).results
      results = Blocktrain::PaginatedQuery.new(search).results

      expect(full_search).to eq(results)
    end

  end
end
