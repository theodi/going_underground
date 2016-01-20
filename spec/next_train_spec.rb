module SirHandel
  describe NextTrains do

    it 'gets a correct naptan ID' do
      next_trains = described_class.new('warren_street', :southbound)
      expect(next_trains.instance_variable_get('@station')).to eq('940GZZLUWRR')
    end

    it 'gets a correct directions' do
      next_trains = described_class.new('warren_street', :northbound)
      expect(next_trains.instance_variable_get('@direction')).to eq('inbound')
    end

    it 'builds a correct url' do
      next_trains = described_class.new('warren_street', :southbound)
      expect(next_trains.url).to eq('https://api.tfl.gov.uk/line/victoria/arrivals?stopPointId=940GZZLUWRR&direction=outbound')
    end

    it 'gets the next trains' do
      json = [
        {
          'timeToStation' => 417
        },
        {
          'timeToStation' => 177
        },
        {
          'timeToStation' => 537
        },
        {
          'timeToStation' => 297
        },
      ]

      stub_request(:get, "https://api.tfl.gov.uk/line/victoria/arrivals?stopPointId=940GZZLUWRR&direction=outbound").
            to_return(:body => json.to_json)

      result = described_class.new('warren_street', :southbound).results

      expect(result[0]).to eq(3)
      expect(result[1]).to eq(5)
      expect(result[2]).to eq(7)
      expect(result[3]).to eq(9)
    end

  end
end
