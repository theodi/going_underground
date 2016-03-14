module Blocktrain
  describe StationCrowding do
    it 'sends the right paramesters to ATPQuery', :vcr do
      from = '1974-06-15T00:00:00+00:00'
      to = '1974-06-15T17:00:00+00:00'

      expect(ATPQuery).to receive(:new).with(from: from, to: to, station: :euston, direction: :southbound) do
        instance_double(ATPQuery, results: [])
      end

      tc = described_class.new Time.parse(to), :euston, :southbound
    end

    it 'gets train loading data for a point in time', :vcr do
      tc = described_class.new Time.parse('2015-12-11T16:02:22.521Z'), :euston, :southbound

      expect(tc.crowd_results Time.parse('2015-12-11T16:02:22.521Z')).to eq({
        "CAR_A" => 8.038461538461538,
        "CAR_B" => 18.6,
        "CAR_C" => 7.625,
        "CAR_D" => 18.0
      })
    end

    it 'has results', :vcr do
      tc = described_class.new Time.parse('2015-12-11T17:00:00.000Z'), :euston, :southbound

      expect(tc.results).to include [
        {
          "segment"=>1193,
          "number"=>0,
          "timeStamp"=>"2015-12-11T16:17:46.934Z"
        },
        {
          "CAR_A"=>28.429378531073446,
          "CAR_B"=>32.40853658536585,
          "CAR_C"=>30.681159420289855,
          "CAR_D"=>44.857142857142854
        }
      ]
    end

    context 'start of the line' do
      it 'knows about the start of the line' do
        tc = described_class.new Time.parse('2015-12-11T17:00:00.000Z'), :walthamstow_central, :southbound

        expect(tc.results).to eq [
          [
            {
              "number"=>0,
              "timeStamp"=>"2015-12-11T17:00:00Z"
            },
            {
              "CAR_A"=>0,
              "CAR_B"=>0,
              "CAR_C"=>0,
              "CAR_D"=>0
            }
          ]
        ]
      end
    end
  end
end
