module Blocktrain
  describe TrainCrowding do
    it 'sends the right paramesters to ATPQuery' do
      from = '1974-06-15T00:00:00+00:00'
      to = '1974-06-15T02:00:00+00:00'

      expect(ATPQuery).to receive(:new).with(from: from, to: to, station: :euston, direction: :southbound)

      tc = described_class.new Time.parse(to), :euston, :southbound
    end
  end
end
