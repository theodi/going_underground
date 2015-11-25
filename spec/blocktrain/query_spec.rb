module Blocktrain
  describe Query do

    it 'queries a single signal', :vcr do
      subject = described_class.new(from: '2015-09-01 10:00:00Z', to: '2015-09-01 11:00:00Z', signals: 'train_speed')

      expect(subject.address_query).to eq('memoryAddress:2E491EEW')
    end

    it 'queries multiple signals', :vcr do
      subject = described_class.new(from: '2015-09-01 10:00:00Z', to: '2015-09-01 11:00:00Z', signals: ['passesnger_load_car_a', 'passesnger_load_car_b', 'passesnger_load_car_c', 'passesnger_load_car_d'])

      expect(subject.address_query).to eq('memoryAddress:2E64930W OR memoryAddress:2E64932W OR memoryAddress:2E64934W OR memoryAddress:2E64936W')
    end

    it 'provides 100 results by default', :vcr do
      subject = described_class.new(from: '2015-09-01 10:00:00Z', to: '2015-09-01 11:00:00Z', signals: 'train_speed')
      expect(subject.results.count).to eq(100)
      expect(subject.hits).to eq(9766)
    end

    it 'provides the correct number of results if limit is specified', :vcr do
      subject = described_class.new(from: '2015-09-01 10:00:00Z', to: '2015-09-01 11:00:00Z', signals: 'train_speed', limit: 10)
      expect(subject.results.count).to eq(10)
      expect(subject.hits).to eq(9766)
    end

  end

end
