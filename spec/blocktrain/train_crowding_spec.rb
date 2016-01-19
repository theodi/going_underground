module Blocktrain
  describe TrainCrowding do
    it 'gets train loading data for a point in time', :vcr do
      tc = described_class.new Time.parse('2015-09-17T16:02:22.521Z'), :euston, :southbound

      expect(tc.crowd_results Time.parse('2015-09-17T16:02:22.521Z')).to eq({
        'CAR_A' => 25.333333333333332,
        'CAR_B' => 33.83582089552239,
        'CAR_C' => 26.193548387096776,
        'CAR_D' => 10.428571428571429
      })
    end

    it 'has results', :vcr do
      tc = described_class.new Time.parse('2015-09-17T17:00:00.000Z'), :euston, :southbound

      expect(tc.results.first).to eq [
        {
          "number"=>0,
          "timeStamp"=>"2015-09-17T16:02:22.521Z"
        },
        {
          "CAR_A"=>25.333333333333332,
          "CAR_B"=>33.83582089552239,
          "CAR_C"=>26.193548387096776,
          "CAR_D"=>10.428571428571429
        }
      ]
    end

    it 'gets dates for the previous 3 days', :vcr do
      tc = described_class.new Time.parse('2015-09-24T09:00:00.000Z'), :euston, :southbound
      results = tc.results

      expect(Time.parse(results[0].first["timeStamp"]).day).to eq(24)
      expect(Time.parse(results[1].first["timeStamp"]).day).to eq(23)
      expect(Time.parse(results[2].first["timeStamp"]).day).to eq(22)
      expect(Time.parse(results[3].first["timeStamp"]).day).to eq(21)
    end

    context 'start of the line' do
      it 'knows about the start of the line' do
        tc = described_class.new Time.parse('2015-09-17T17:00:00.000Z'), :walthamstow_central, :southbound

        expect(tc.results).to eq [
          [
            {
              "number"=>0,
              "timeStamp"=>"2015-09-17T17:00:00Z"
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
