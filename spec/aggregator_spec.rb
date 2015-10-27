### module Blocktrain
###   describe Client do
###
###     describe 'hour long histogram' do
###       subject(:client) {
###         described_class.new(from: '2015-09-01 10:00:00Z', to: '2015-09-01 11:00:00Z', interval: '10m')
###       }
###       let(:aggregations) {
###         client.results['aggregations']
###       }
###
###       it 'has an aggregation called weight_chart', :vcr do
###         expect(aggregations).to have_key('weight_chart')
###       end
###
###       it 'has 6 buckets in result', :vcr do
###         expect(aggregations['weight_chart']['buckets'].count).to eql(6)
###       end
###
###       it 'has a value called weight', :vcr do
###         expect(aggregations['weight_chart']['buckets'].first).to have_key('weight')
###       end
###     end
###
###   end
### end
### 
