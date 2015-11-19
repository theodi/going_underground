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
  end
end
