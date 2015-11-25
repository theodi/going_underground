module SirHandel
  describe Helpers do
    let(:helpers) { TestHelpers.new }

    it 'returns straight away if rack env is test' do
      expect(ENV).to receive(:[]).with('RACK_ENV').and_return('test')

      expect(helpers.protected!).to eq(nil)
    end

    it 'returns nil if authorized is true' do
      expect(ENV).to receive(:[]).with('RACK_ENV').and_return('production')
      expect(helpers).to receive(:authorized?).and_return(true)

      expect(helpers.protected!).to eq(nil)
    end

    it 'authorises correctly' do
      user = 'bort'
      password = 'malk'
      base64 = Base64.encode64("#{user}:#{password}")

      expect(ENV).to receive(:[]).with('TUBE_USERNAME').and_return(user)
      expect(ENV).to receive(:[]).with('TUBE_PASSWORD').and_return(password)

      expect(helpers).to receive(:env).and_return({
        'HTTP_AUTHORIZATION' => "Basic #{base64}\n",
      })

      expect(helpers.authorized?).to eq(true)
    end

    context 'round_up' do

      it 'rounds up dates' do
        (1..23).each do |h|
          date = DateTime.parse("2015-08-28T#{"%02d" % h}:00:00+00:00")
          expect(helpers.round_up(date)).to eq(DateTime.parse('2015-08-29T00:00:00+00:00'))
        end
      end

      it 'rounds up dates with odd minutes and seconds' do
        (1..23).each do |h|
          date = DateTime.parse("2015-08-28T#{"%02d" % h}:#{rand(59) % h}:#{rand(59) % h}+00:00")
          expect(helpers.round_up(date)).to eq(DateTime.parse('2015-08-29T00:00:00+00:00'))
        end
      end

      it 'leaves midnight untouched' do
        date = DateTime.parse("2015-08-28T00:00:00+00:00")
        expect(helpers.round_up(date)).to eq(date)
      end

    end

    it 'parameterizing signal names' do
      expect(helpers.db_signal 'signal-1').to eq('signal_1')
      expect(helpers.web_signal 'signal_1').to eq('signal-1')
    end

    it 'generates signal urls' do
      url = helpers.signal_path('actual_motor_power', :json)
      expect(url).to eq('/signals/actual-motor-power.json')
    end

  end
end
