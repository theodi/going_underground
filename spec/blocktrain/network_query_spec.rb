module Blocktrain
  describe NetworkQuery do

    it 'sets to and from to be within a 60 minute window' do
      subject = described_class.new(datetime: '2015-09-01 10:00:00Z', signal: '2E491EEW')

      expect(subject.instance_variable_get("@from")).to eq(Time.parse "2015-09-01 09:30:00Z")
      expect(subject.instance_variable_get("@to")).to eq(Time.parse "2015-09-01 10:30:00Z")
    end

    it 'gets maximums within two minute windows', :vcr do
      subject = described_class.new(datetime: '2015-09-01 10:15:00Z', signal: '2E491EEW')

      results = subject.results

      expect(results.first['timestamp']).to eq('2015-09-01T09:48:00.000Z')
      expect(results.last['timestamp']).to eq('2015-09-01T10:38:00.000Z')
    end

  end
end
