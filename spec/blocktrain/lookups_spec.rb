module Blocktrain
  describe Lookups do

    it 'knows about car codes' do
      expect(described_class.instance.lookups['passenger_load']['A']).to eq '2E64930W'
    end

    it 'is an OpenStruct' do
      expect(described_class.instance.lookups.passenger_load['B']).to eq '2E64932W'
    end

  end
end
