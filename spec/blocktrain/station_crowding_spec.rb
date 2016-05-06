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

      expect(tc.crowd_results Time.parse('2015-12-11T16:02:22.521Z')).to eq({:front=>{"CAR_A"=>7.142857142857143, "CAR_B"=>25.4375, "CAR_C"=>9.846153846153847, "CAR_D"=>17.916666666666668}, :back=>{"CAR_A"=>8.368421052631579, "CAR_B"=>14.041666666666666, "CAR_C"=>6.105263157894737, "CAR_D"=>18.045454545454547}})
    end

    it 'has results', :vcr do
      tc = described_class.new Time.parse('2015-12-11T17:00:00.000Z'), :euston, :southbound

      expect(tc.results).to include [
        {"segment" => 1193, "number" => 0, "timeStamp" => "2015-12-11T16:17:46.934Z"},
        {
          :front => {
            "CAR_A" => 43.39795918367347,
            "CAR_B" => 46.67123287671233,
            "CAR_C" => 29.416666666666668,
            "CAR_D" => 52.056338028169016
          },
          :back => {
            "CAR_A" => 9.860759493670885,
            "CAR_B" => 20.967032967032967,
            "CAR_C" => 31.653846153846153,
            "CAR_D" => 37.44927536231884
          }
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
