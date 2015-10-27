module Blocktrain
  describe Client do
    let(:query) {
      JSON.parse File.read 'spec/support/fixtures/query.json'
    }

    it 'performs a search', :vcr do
      expect(described_class.results(query)).to have_key 'aggregations'
    end

  end
end
