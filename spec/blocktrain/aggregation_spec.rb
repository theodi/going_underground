module Blocktrain
  describe Aggregation do

    it 'gets the interval' do
      subject = described_class.new(from: '2015-09-01 10:00:00Z', to: '2015-09-01 11:00:00Z', interval: '10m', signal: 'passenger_load')

      expect(subject.instance_variable_get("@interval")).to eq('10m')
    end

  end
end
