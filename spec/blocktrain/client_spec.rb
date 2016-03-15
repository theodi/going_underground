module Blocktrain
  describe Client do

    let(:query) {
      JSON.parse File.read 'spec/support/fixtures/query.json'
    }

    it 'performs a search', :vcr do
      expect(described_class.results(query)).to have_key 'aggregations'
    end

    it 'builds the endpoint' do
      allow(ENV).to receive(:[]).with('ES_URL') { 'http://elastic.search' }

      expect(described_class.endpoint('search', 'train_data')).to eq("http://elastic.search/train_data/_search")
    end

  end
end
