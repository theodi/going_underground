module Blocktrain
  describe CarWeightAggregation do

    describe 'hour long histogram' do

      subject(:aggregations) {
        described_class.new(from: '2015-09-01 10:00:00Z', to: '2015-09-01 11:00:00Z').results
      }

      it 'has an aggregation called weight_chart' do
        expect(aggregations).to have_key 'weight'
        expect(aggregations['weight']).to have_key 'buckets'
        expect(aggregations['weight']['buckets'].count).to eq 4
        expect(aggregations['weight']['buckets'][0].keys).to include 'max_weight', 'min_weight', 'avg_weight'
        expect(aggregations['weight']['buckets'][2]['avg_weight']['value']).to be_within(0.1).of 22.7
      end

    end
  end
end
