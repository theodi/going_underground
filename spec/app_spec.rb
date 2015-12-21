module SirHandel
  describe App, :vcr do

    it 'should allow accessing the home page' do
      get '/'
      expect(last_response.body).to match(/a href='\/signals/)
      expect(last_response.body).to match(/a href='\/stations/)
    end

    it 'varys on the accept header for signals' do
      get '/signals'
      expect(last_response.headers['Vary']).to eq('Accept')
    end

    it 'varys on the accept header for a particular signal' do
      get '/signals/passesnger-load-car-a/2015-08-29T00:00:00+00:00/2015-08-30T00:00:00+00:00?interval=10m'
      expect(last_response.headers['Vary']).to eq('Accept')
    end

    it 'should list the signals' do
      expect_any_instance_of(described_class).to receive(:groups) {
        {
          'group_1' => [
            'thing_1',
            'thing_2'
          ]
        }
      }

      expect_any_instance_of(described_class).to receive(:lookups) {
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

    it 'should group signals' do
      expect_any_instance_of(described_class).to receive(:groups) {
        {
          'group_1' => [
            'line_current',
            'line_voltage'
          ]
        }
      }

      get '/signals'

      body = Nokogiri::HTML.parse(last_response.body)

      expect(body.css('#group_1').first.css('div').count).to eq(3)
      expect(body.css('#group_1').first.css('div').first.to_s).to match /Line Current/

      expect(body.css('#ungrouped').first.to_s).to_not match /Line Current/
    end

    it 'should show a grouped link' do
      expect_any_instance_of(described_class).to receive(:groups) {
        {
          'group_1' => [
            'line_current',
            'line_voltage'
          ]
        }
      }

      get '/signals'

      body = Nokogiri::HTML.parse(last_response.body)
      expect(body.css('#group_1').last.css('div').last.to_s).to match /group_1 Grouped/
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

    it 'redirects to a RESTful URL with a group' do
      post '/groups/my-awesome-group', {
        from: '2015-09-03 07:00:00',
        to: '2015-09-03 10:00:00',
        interval: '5s' }

      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.url).to eq 'http://example.org/groups/my-awesome-group/2015-09-03T07:00:00+00:00/2015-09-03T10:00:00+00:00?interval=5s'
    end

    it 'redirects with a comparison' do
      post '/signals/passesnger-load-car-a', {
        compare: 'passesnger-load-car-b'
      }

      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.url).to eq 'http://example.org/signals/passesnger-load-car-a,passesnger-load-car-b/2015-08-29T00:00:00+00:00/2015-08-30T00:00:00+00:00'
    end

    it 'redirects with a new comparison' do
      post '/signals/passesnger-load-car-a,passesnger-load-car-b', {
        compare: 'passesnger-load-car-c'
      }

      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.url).to eq 'http://example.org/signals/passesnger-load-car-a,passesnger-load-car-c/2015-08-29T00:00:00+00:00/2015-08-30T00:00:00+00:00'
    end

    it 'redirects with defaults' do
      post '/signals/passesnger-load-car-a', {
        from: '',
        to: '',
        interval: ''
      }

      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.url).to eq 'http://example.org/signals/passesnger-load-car-a/2015-08-29T00:00:00+00:00/2015-08-30T00:00:00+00:00'
    end

    it 'redirects to default datetimes' do
      get '/signals/passesnger-load-car-a'

      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.url).to eq 'http://example.org/signals/passesnger-load-car-a/2015-08-29T00:00:00+00:00/2015-08-30T00:00:00+00:00'
    end

    it 'redirects to default datetimes with a group' do
      get '/groups/passesnger-load'

      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.url).to eq 'http://example.org/groups/passesnger-load/2015-08-29T00:00:00+00:00/2015-08-30T00:00:00+00:00'
    end

    it 'returns 404 for an unknown redirect type' do
      get '/foobar/passesnger-load'

      expect(last_response.status).to eq(404)
    end

    it 'shows the title of a signal' do
      get '/signals/passesnger-load-car-a/2015-08-29T00:00:00+00:00/2015-08-30T00:00:00+00:00?interval=10m'
      expect(last_response.body).to match(/Passenger Load Car A \(%\)<\/h1>/)
    end

    it 'shows the title of two signals' do
      get '/signals/passesnger-load-car-a,passesnger-load-car-b/2015-08-29T00:00:00+00:00/2015-08-30T00:00:00+00:00?interval=10m'
      expect(last_response.body).to match(/Passenger Load Car A \(%\) compared with Passenger Load Car B \(%\)<\/h1>/)
    end

    it 'allows a layout to be specified' do
      expect_any_instance_of(SirHandel::App).to receive(:erb).with(:signal, { layout: :simple })
      get '/signals/passesnger-load-car-a,passesnger-load-car-b/2015-08-29T00:00:00+00:00/2015-08-30T00:00:00+00:00?layout=simple'
    end

    it 'sets a default datetime' do
      get 'stations/arriving/southbound/seven-sisters'
      follow_redirect!
      expect(last_request.url).to eq 'http://example.org/stations/arriving/southbound/seven-sisters/2015-09-23T08:30:00+00:00'
    end

    it 'allows the datetime to be set', :vcr do
      to = "2015-09-23T17:10:00Z"
      expect(Blocktrain::StationCrowding).to receive(:new).with(Time.parse(to), "seven_sisters", :southbound).and_call_original
      get "stations/arriving/southbound/seven-sisters/#{to}.json"
    end

    it 'shows all stations' do
      get 'stations'

      body = Nokogiri::HTML.parse(last_response.body)

      expect(body.css('#northbound').first.css('li').count).to eq(16)
      expect(body.css('#southbound').first.css('li').count).to eq(16)
    end
  end
end
