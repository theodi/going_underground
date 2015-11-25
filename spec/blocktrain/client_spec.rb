module Blocktrain
  describe Client do

    let(:query) {
      JSON.parse File.read 'spec/support/fixtures/query.json'
    }

    it 'performs a search', :vcr do
      expect(described_class.results(query)).to have_key 'aggregations'
    end

    it 'provides a default index' do
      allow(ENV).to receive(:[]).with('ES_INDEX') { nil }

      expect(described_class.index).to eq('train_data')
    end

    it 'allows the index to be configured' do
      allow(ENV).to receive(:[]).with('ES_INDEX') { 'my_cool_index' }

      expect(described_class.index).to eq('my_cool_index')
    end

    it 'builds the endpoint' do
      allow(ENV).to receive(:[]).with('ES_INDEX') { nil }
      allow(ENV).to receive(:[]).with('ES_URL') { 'http://elastic.search' }

      expect(described_class.endpoint).to eq("http://elastic.search/train_data/_search")
    end

  end
end
