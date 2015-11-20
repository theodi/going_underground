module SirHandel
  describe App, :vcr do

    it 'constructs a URL' do
      expect(SirHandel::build_url 'actual_motor_power', 'http://example.org').to eq 'http://example.org/signals/actual-motor-power.json'
    end

    it 'parameterizes signal names' do
      expect(SirHandel::parameterize_signal 'signal-1').to eq('signal_1')
    end

    it 'should allow accessing the home page' do
      get '/'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.url). to eq 'http://example.org/signals'
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

      get '/signals'

      expect(last_response.body).to match(/thing_3/)
      expect(last_response.body).to_not match(/thing_4/)
    end

    it 'should list the signals' do
      expect(Blocktrain::Lookups.instance).to receive(:aliases) {
        {
          'thing_1' => '1',
          'thing_2' => '2',
          'thing_3' => '3',
          'thing_4' => nil
        }
      }

      get '/signals', {signal: 'thing_3'}

      expect(last_response.body).to match(/a href="http:\/\/example\.org\/signals\/thing-1/)
      expect(last_response.body).to match(/a href="http:\/\/example\.org\/signals\/thing-2/)
      expect(last_response.body).to match(/a href="http:\/\/example\.org\/signals\/thing-3/)
    end

    it 'redirects to a RESTful URL' do
      post '/signals/passesnger-load-car-a', {
        from: '2015-09-03 07:00:00',
        to: '2015-09-03 10:00:00',
        interval: '5s' }

      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.url).to eq 'http://example.org/signals/passesnger-load-car-a/2015-09-03T07:00:00+00:00/2015-09-03T10:00:00+00:00?interval=5s'
    end

    it 'redirects with defaults' do
      post '/signals/passesnger-load-car-a', {
        from: '',
        to: '',
        interval: ''
      }

      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.url).to eq 'http://example.org/signals/passesnger-load-car-a/2015-09-01T00:00:00+00:00/2015-09-02T00:00:00+00:00?interval=10m'
    end

    it 'redirects to default datetimes' do
      get '/signals/passesnger-load-car-a'

      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.url).to eq 'http://example.org/signals/passesnger-load-car-a/2015-09-01T00:00:00+00:00/2015-09-02T00:00:00+00:00?interval=10m'
    end
  end
end
