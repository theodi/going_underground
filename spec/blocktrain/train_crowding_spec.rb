module Blocktrain
  describe TrainCrowding do
    it 'sends the right paramesters to ATPQuery' do
      from = '1974-06-14T00:00:00+00:00'
      to = '1974-06-15T00:00:00+00:00'

      expect(ATPQuery).to receive(:new).with(from: from, to: to, station: :euston, direction: :southbound)

      tc = described_class.new Time.parse(to), :euston, :southbound
    end

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

      expect(tc.results).to eq [
        [
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
      ]
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
