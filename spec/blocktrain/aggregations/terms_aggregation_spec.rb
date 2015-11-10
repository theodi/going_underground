module Blocktrain
  module Aggregations
    describe TermsAggregation do

      it 'can find unique memory addresses' do
        r = described_class.new(from: '2015-09-01 10:00:00Z', to: '2015-09-01 11:00:00Z', term: "memoryAddress").results
        keys = r.map {|x| x["key"]}
        expect(keys.count).to eq(10)
        expect(keys.uniq.count).to eq(10)
        expect(keys).to include("2E4414CW")
        expect(keys).to include("2E491EEW")
      end
    end
  end
end
