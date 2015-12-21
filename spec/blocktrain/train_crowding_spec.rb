module Blocktrain
  describe TrainCrowding do
    it 'gets some results', :vcr do
      results = Blocktrain::Query.new(from: '2015-09-23T08:00:00Z', to: '2015-09-23T08:10:00Z', memory_addresses: ['2E5485AW'], sort: {'timeStamp' => 'desc'}).results
      crowding = Blocktrain::TrainCrowding.new(results).results

      expect(crowding.count).to eq(results.count)
      expect(crowding.first).to eq([
        {
          "number"=>0,
          "timeStamp"=>"2015-09-23T08:08:01.928Z"
        },
        {
          "CAR_A"=>11.102564102564102,
          "CAR_B"=>4.34375,
          "CAR_C"=>1.5217391304347827,
          "CAR_D"=>1.4516129032258065
        }
      ])
    end

    it 'gets results for a particular time', :vcr do
      results = Blocktrain::Query.new(from: '2015-09-23T08:00:00Z', to: '2015-09-23T08:10:00Z', memory_addresses: ['2E5485AW'], sort: {'timeStamp' => 'desc'}).results
      crowding = Blocktrain::TrainCrowding.new(results)

      expect(crowding.crowd_results(Time.parse "2015-09-23T08:08:01.928Z")).to eq({
        "CAR_A"=>11.102564102564102,
        "CAR_B"=>4.34375,
        "CAR_C"=>1.5217391304347827,
        "CAR_D"=>1.4516129032258065
      })
    end
  end
end
