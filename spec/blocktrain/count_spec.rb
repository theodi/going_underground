module Blocktrain
  describe Count do

    it 'gets the total count of results', :vcr do
      subject = described_class.new(from: '2015-09-01 10:00:00Z', to: '2015-09-01 11:00:00Z', memory_addresses: '2E491EEW')

      expect(subject.results).to eq(9766)
    end

  end
end
