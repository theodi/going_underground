module Blocktrain
  describe TrainCrowding do
    it 'gets some results', :vcr do
      results = Blocktrain::Query.new(from: '2015-12-11T08:00:00Z', to: '2015-12-11T08:10:00Z', memory_addresses: ['2E5485AW'], sort: {'timeStamp' => 'desc'}).results
      crowding = Blocktrain::TrainCrowding.new(results).results

      expect(crowding.count).to eq(results.count)
      expect(crowding.first).to eq([{"segment"=>1285, "number"=>0, "timeStamp"=>"2015-12-11T08:09:58.215Z"}, {:front=>{"CAR_A"=>62.208333333333336, "CAR_B"=>76.04255319148936, "CAR_C"=>56.64705882352941, "CAR_D"=>81.15384615384616}, :back=>{"CAR_A"=>52.06818181818182, "CAR_B"=>70.33962264150944, "CAR_C"=>67.62, "CAR_D"=>65.37837837837837}}])
    end

    it 'gets results for a particular time', :vcr do
      results = Blocktrain::Query.new(from: '2015-12-11T08:00:00Z', to: '2015-12-11T08:10:00Z', memory_addresses: ['2E5485AW'], sort: {'timeStamp' => 'desc'}).results
      crowding = Blocktrain::TrainCrowding.new(results)

      expect(crowding.crowd_results(Time.parse "2015-12-11T08:08:01.928Z")).to eq({:front=>{"CAR_A"=>81.00980392156863, "CAR_B"=>95.80208333333333, "CAR_C"=>60.83516483516483, "CAR_D"=>93.5}, :back=>{"CAR_A"=>48.8876404494382, "CAR_B"=>58.37, "CAR_C"=>65.38372093023256, "CAR_D"=>70.14772727272727}})
    end
  end
end
