module SirHandel
  describe App, :vcr do

    it 'constructs a URL' do
      expect(SirHandel::build_url 'actual_motor_power', 'http://example.org').to eq 'http://example.org/signals/actual-motor-power.json'
    end

    it 'should allow accessing the home page' do
      get '/'
      expect(last_response).to be_ok
    end

    it 'should delete aliases with no signal name' do
      expect(Blocktrain::Lookups.instance).to receive(:aliases) {
        {
          'thing_1' => '1',
          'thing_2' => '2',
          'thing_3' => '3',
          'thing_4' => nil
        }
      }

      get '/signal'

      expect(last_response.body).to match(/thing_3/)
      expect(last_response.body).to_not match(/thing_4/)
    end

    it 'should set the selected signal to selected' do
      expect(Blocktrain::Lookups.instance).to receive(:aliases) {
        {
          'thing_1' => '1',
          'thing_2' => '2',
          'thing_3' => '3',
          'thing_4' => nil
        }
      }

      get '/signal', {signal: 'thing_3'}

      expect(last_response.body).to match(/<option selected='selected'>thing_3<\/option>/)
    end

###    it 'should return some default data' do
###      pending 'Moving tests to Cucumber'
###      get '/signal.json'
###
###      json = JSON.parse(last_response.body)
###
###      expect(json['results'].first).to eq({
###        'timestamp'=>'2015-09-01T00:00:00+00:00',
###        'value'=>0.0
###      })
###
###      expect(json['results'].last).to eq({
###        'timestamp'=>'2015-09-01T23:00:00+00:00',
###        'value'=>5308.094351083215
###      })
###    end
###
###    it 'should allow the date to be specified' do
###      pending 'Moving tests to Cucumber'
###
###      get '/signal.json', from: '2015-09-23 00:00:00Z', to: '2015-09-24 00:00:00Z'
###
###      json = JSON.parse(last_response.body)
###
###      expect(json['results'].first['timestamp']).to eq('2015-09-23T04:00:00+00:00')
###    end
###
###    it 'should allow the interval to be specified' do
###      pending 'Moving tests to Cucumber'
###
###      expect(Blocktrain::Aggregations::AverageAggregation).to receive(:new).with(hash_including(interval: '1h')).and_call_original
###      get '/signal.json', interval: '1h'
###    end
###
  end
end
