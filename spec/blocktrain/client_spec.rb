module Blocktrain
  describe Client do

    describe 'creating client' do
      it 'allows the url to be configured' do
        client = wrap_env('ES_URL' => 'http://elastic.search') do
          described_class.new
        end
        expect(client.url).to eq(URI('http://elastic.search'))
      end

      it 'provides a default index' do
        client = described_class.new
        expect(client.index).to eq('train_data')
      end

      it 'allows the index to be configured' do
        client = wrap_env('ES_INDEX' => 'my_cool_index') do
          described_class.new
        end
        expect(client.index).to eq('my_cool_index')
      end

      it 'allows the index to be provided' do
        client = wrap_env('ES_INDEX' => 'index_name') do
          described_class.new(nil, 'another_cool_index')
        end
        expect(client.index).to eq('another_cool_index')
      end

      it 'builds the endpoint' do
        client = wrap_env('ES_URL' => 'http://elastic.search') do
          described_class.new
        end
        expect(client.endpoint('_search')).to eq("http://elastic.search/train_data/_search")
      end

    end

    describe 'querying' do
      subject(:client) { described_class.new }

      let(:query) do
        JSON.parse File.read 'spec/support/fixtures/query.json'
      end

      it 'performs a search', :vcr do
        expect(client.search(query)).to have_key 'aggregations'
      end
    end

  end
end
