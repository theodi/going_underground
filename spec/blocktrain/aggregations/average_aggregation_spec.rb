module Blocktrain
  module Aggregations
    describe AverageAggregation do

      describe 'hour long histogram' do

        subject(:aggregations) {
          described_class.new(from: '2015-09-01 10:00:00Z', to: '2015-09-01 11:00:00Z', interval: '10m', signal: 'passenger_load').results
        }

        it 'has an aggregation called results', :vcr do
          expect(aggregations).to have_key('results')
        end

        it 'has 6 buckets in result', :vcr do
          expect(aggregations['results']['buckets'].count).to eql(6)
        end

        it 'has a value called average_value', :vcr do
          expect(aggregations['results']['buckets'].first).to have_key('average_value')
        end

        it 'has the expected weight', :vcr do
          expect(aggregations['results']['buckets'].first['average_value']['value']).to be_within(0.1).of 37.7
        end

      end
    end
  end
end
