module Blocktrain
  module Aggregations
    describe TermsAggregation do

      it 'can find unique memory addresses', :vcr do
        r = described_class.new(from: '2015-12-10 10:00:00Z', to: '2015-12-10 11:00:00Z', term: "memoryAddress").results
        keys = r.map {|x| x["key"]}
        expect(keys.count).to eq(112)
        expect(keys.uniq.count).to eq(112)
        expect(keys).to include("2e4414cw")
        expect(keys).to include("2e491eew")
      end
    end
  end
end
