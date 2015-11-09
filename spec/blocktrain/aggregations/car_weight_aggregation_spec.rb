module Blocktrain
  module Aggregations
    describe CarWeightAggregation do

      describe 'hour long histogram' do

        subject(:aggregations) {
          described_class.new(from: '2015-09-01 10:00:00Z', to: '2015-09-01 11:00:00Z', signal: 'passenger_load').results
        }

        it 'has an aggregation called weight_chart' do
          expect(aggregations).to have_key 'weight_chart'
          expect(aggregations['weight_chart']).to have_key 'buckets'
          expect(aggregations['weight_chart']['buckets'].count).to eq 6
          expect(aggregations['weight_chart']['buckets'][0]['weight']['buckets'][0].keys).to include 'max_weight', 'min_weight', 'avg_weight'
          expect(aggregations['weight_chart']['buckets'][2]['weight']['buckets'][2]['avg_weight']['value']).to be_within(0.1).of 4.04
        end

      end
    end
  end
end
