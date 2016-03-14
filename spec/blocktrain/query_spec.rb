module Blocktrain
  describe Query do

    it 'queries a single signal', :vcr do
      subject = described_class.new(from: '2015-09-01 10:00:00Z', to: '2015-09-01 11:00:00Z', memory_addresses: '2E491EEW')

      expect(subject.address_query).to eq('memoryAddress:2E491EEW')
    end

    it 'queries multiple signals', :vcr do
      subject = described_class.new(from: '2015-09-01 10:00:00Z', to: '2015-09-01 11:00:00Z', memory_addresses: ['2E64930W', '2E64932W', '2E64934W', '2E64936W'])

      expect(subject.address_query).to eq('memoryAddress:2E64930W OR memoryAddress:2E64932W OR memoryAddress:2E64934W OR memoryAddress:2E64936W')
    end

    it 'provides all results by default', :vcr do
      subject = described_class.new(from: '2015-09-01 10:00:00Z', to: '2015-09-01 11:00:00Z', memory_addresses: '2E491EEW')
      expect(subject.results.count).to eq(9766)
      expect(subject.hits).to eq(9766)
    end

    it 'provides the correct number of results if limit is specified', :vcr do
      subject = described_class.new(from: '2015-09-01 10:00:00Z', to: '2015-09-01 11:00:00Z', memory_addresses: '2E491EEW', limit: 10)
      expect(subject.results.count).to eq(10)
      expect(subject.hits).to eq(9766)
    end

    it 'allows results to be sorted', :vcr do
      subject = described_class.new(from: '2015-09-01 10:00:00Z', to: '2015-09-01 11:00:00Z', memory_addresses: '2E491EEW', limit: 10, sort: { timeStamp: 'asc' })
      expect(subject.results.first['_source']['timeStamp']).to match(/2015-09-01T10:00:/)
    end

    it 'gets the index name' do
      subject = described_class.new(from: '2015-09-01 10:00:00Z', to: '2015-09-01 11:00:00Z', memory_addresses: '2E491EEW', limit: 10, sort: { timeStamp: 'asc' })
      expect(subject.index_name).to eq('train_data_2015_9_1')
    end

    it 'returns an error if to and from span over a day' do
      subject = described_class.new(from: '2015-09-01 10:00:00Z', to: '2015-09-02 11:00:00Z', memory_addresses: '2E491EEW', limit: 10, sort: { timeStamp: 'asc' })
      expect { subject.index_name }.to raise_error(RuntimeError, "Queries can only span one day")
    end

  end

end
