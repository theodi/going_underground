module Blocktrain
  describe Count do

    it 'gets the total count of results', :vcr do
      subject = described_class.new(from: '2015-12-10 10:00:00Z', to: '2015-12-10 11:00:00Z', memory_addresses: '2E491EEW')

      expect(subject.results).to eq(6027)
    end

  end
end
