module SirHandel
  describe NextTrains do

    before(:each) do
      @subject = described_class.new('warren_street', :southbound)
    end

    it 'gets a correct naptan ID' do
      expect(@subject.instance_variable_get('@station')).to eq('940GZZLUWRR')
    end

    it 'gets a correct directions' do
      expect(@subject.instance_variable_get('@direction')).to eq('outbound')
    end

    it 'builds a correct url' do
      expect(@subject.url).to eq('https://api.tfl.gov.uk/line/victoria/arrivals?stopPointId=940GZZLUWRR&direction=outbound')
    end

    it "formats the time in minutes" do
      expect(@subject.format_time(537)).to eq("9 minutes")
    end

    it "formats the time in seconds" do
      expect(@subject.format_time(59)).to eq("less than a minute")
    end

    it 'gets the next trains' do
      json = [
        {
          'timeToStation' => 39
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

      expect(result[0]).to eq("Arriving in less than a minute")
      expect(result[1]).to eq("Arriving in 3 minutes")
      expect(result[2]).to eq("Arriving in 5 minutes")
      expect(result[3]).to eq("Arriving in 9 minutes")
    end

  end
end
