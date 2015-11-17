module SirHandel
  describe App, :vcr do

    it 'should allow accessing the home page' do
      get '/'
      expect(last_response).to be_ok
    end

    it 'should return some default data' do
      get '/signal.json'

      json = JSON.parse(last_response.body)

      expect(json['results'].first).to eq({
        'timestamp'=>'2015-09-01T00:00:00+00:00',
        'value'=>0.0
      })

      expect(json['results'].last).to eq({
        'timestamp'=>'2015-09-01T23:00:00+00:00',
        'value'=>5308.094351083215
      })
    end

    it 'should return min and max data' do
      get '/signal.json'

      json = JSON.parse(last_response.body)

      expect(json['min']).to eq(0.0)
      expect(json['max']).to eq(5858.588810837933)
    end

    it 'should allow the date to be specified' do
      get '/signal.json', from: '2015-09-23 00:00:00Z', to: '2015-09-24 00:00:00Z'

      json = JSON.parse(last_response.body)

      expect(json['results'].first['timestamp']).to eq('2015-09-23T04:00:00+00:00')
    end

    it 'should allow the interval to be specified' do
      expect(Blocktrain::Aggregations::AverageAggregation).to receive(:new).with(hash_including(interval: '1h')).and_call_original
      get '/signal.json', interval: '1h'
    end

  end
end
