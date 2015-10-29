module Blocktrain
  describe OtherAggregation do

    describe 'hour long histogram' do

      subject(:aggregations) {
        described_class.new(from: '2015-09-01 10:00:00Z', to: '2015-09-01 11:00:00Z').results
      }

      it 'has an aggregation called weight_chart' do
        expect(aggregations).to have_key 'weight'
      end

    end
  end
end
