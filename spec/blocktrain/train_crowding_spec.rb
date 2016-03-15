module Blocktrain
  describe TrainCrowding do
    it 'gets some results', :vcr do
      results = Blocktrain::Query.new(from: '2015-12-11T08:00:00Z', to: '2015-12-11T08:10:00Z', memory_addresses: ['2E5485AW'], sort: {'timeStamp' => 'desc'}).results
      crowding = Blocktrain::TrainCrowding.new(results).results

      expect(crowding.count).to eq(results.count)
      expect(crowding.first).to eq([{"segment"=>1285, "number"=>0, "timeStamp"=>"2015-12-11T08:09:58.215Z"}, {"CAR_A"=>57.358695652173914, "CAR_B"=>73.02, "CAR_C"=>63.17857142857143, "CAR_D"=>73.47368421052632}])
    end

    it 'gets results for a particular time', :vcr do
      results = Blocktrain::Query.new(from: '2015-12-11T08:00:00Z', to: '2015-12-11T08:10:00Z', memory_addresses: ['2E5485AW'], sort: {'timeStamp' => 'desc'}).results
      crowding = Blocktrain::TrainCrowding.new(results)

      expect(crowding.crowd_results(Time.parse "2015-12-11T08:08:01.928Z")).to eq({"CAR_A"=>66.04188481675392, "CAR_B"=>76.70408163265306, "CAR_C"=>63.045197740113, "CAR_D"=>82.08333333333333})
    end
  end
end
