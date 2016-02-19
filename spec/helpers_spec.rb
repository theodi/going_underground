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

    it 'generates group urls' do
      url = helpers.group_path('my_awesome_group', :json)
      expect(url).to eq('/groups/my-awesome-group.json')
    end

    it 'gets the correct direction' do
      expect(helpers.get_direction 137).to eq('southbound')
      expect(helpers.get_direction 152).to eq('northbound')
    end

    it 'gets the correct station' do
      {
        'walthamstow_central' => [
          99,
          10
        ],
        'blackhorse_road' => [
          161,
          104
        ],
        'tottenham_hale' => [
          217,
          182
        ],
        'seven_sisters' => [
          345,
          456
        ],
        'finsbury_park' => [
          921,
          842
        ],
        'highbury_and_islington' => [
          1105,
          1010
        ],
        'kings_cross_st_pancras' => [
          1285,
          1146
        ],
        'euston' => [
          1321,
          1210
        ],
        'warren_street' => [
          1427,
          1342
        ],
        'oxford_circus' => [
          1491,
          1416
        ],
        'green_park' => [
          1573,
          1480
        ],
        'victoria' => [
          1677,
          1578
        ],
        'pimlico' => [
          1785,
          1750
        ],
        'vauxhall' => [
          1833,
          1782
        ],
        'stockwell' => [
          1911,
          1888
        ],
        'brixton' => [
          2031,
          1960
        ]
      }.each do |k,v|
        expect(helpers.get_station v.first).to eq(k)
        expect(helpers.get_station v.last).to eq(k)
      end
    end

    context('heatmap') do
      it 'gets a heatmap', :vcr do
        date = '2015-09-23T17:10:00Z'
        expect(helpers.heatmap(date)).to eq([
          {segment:1794, station:"vauxhall", direction:"northbound", load:14.666694206512755},
          {segment:1892, station:"stockwell", direction:"northbound", load:11.681944444444444},
          {segment:1999, station:"stockwell", direction:"southbound", load:30.084578161003556},
          {segment:1881, station:"vauxhall", direction:"southbound", load:43.350831430318934},
          {segment:1793, station:"pimlico", direction:"southbound", load:53.23052300174797},
          {segment:1681, station:"victoria", direction:"southbound", load:57.001145337653135},
          {segment:1565, station:"green_park", direction:"southbound", load:97.07543448715087},
          {segment:1487, station:"oxford_circus", direction:"southbound", load:94.94368275515336},
          {segment:893, station:"seven_sisters", direction:"southbound", load:24.849155220589473},
          {segment:297, station:"tottenham_hale", direction:"southbound", load:10.826860508464282},
          {segment:195, station:"blackhorse_road", direction:"southbound", load:5.4407673395445135},
          {segment:119, station:"walthamstow_central", direction:"southbound", load:4.4395012689378595},
          {segment:600, station:"finsbury_park", direction:"northbound", load:70.67649122807018},
          {segment:870, station:"highbury_and_islington", direction:"northbound", load:86.94923155737705},
          {segment:1026, station:"kings_cross_st_pancras", direction:"northbound", load:89.4342820479},
          {segment:1282, station:"euston", direction:"northbound", load:82.932464411741},
          {segment:1358, station:"warren_street", direction:"northbound", load:86.75000130493461},
          {segment:1444, station:"green_park", direction:"northbound", load:71.93170006408403},
          {segment:1522, station:"victoria", direction:"northbound", load:62.61486433754038},
          {segment:1642, station:"pimlico", direction:"northbound", load:29.57324973182908}
        ])
      end
    end

    context 'date_step' do
      let(:from) { DateTime.parse("2015-09-23T09:00:00") }
      let(:to) { DateTime.parse("2015-09-23T09:30:00") }

      it 'gets a default date step' do
        range = helpers.date_step(from, to)

        expect(range).to eq([
          DateTime.parse("2015-09-23T09:00:00"),
          DateTime.parse("2015-09-23T09:05:00"),
          DateTime.parse("2015-09-23T09:10:00"),
          DateTime.parse("2015-09-23T09:15:00"),
          DateTime.parse("2015-09-23T09:20:00"),
          DateTime.parse("2015-09-23T09:25:00"),
          DateTime.parse("2015-09-23T09:30:00")
        ])
      end

      it 'gets a date step every 10 minutes' do
        range = helpers.date_step(from, to, 10)

        expect(range).to eq([
          DateTime.parse("2015-09-23T09:00:00"),
          DateTime.parse("2015-09-23T09:10:00"),
          DateTime.parse("2015-09-23T09:20:00"),
          DateTime.parse("2015-09-23T09:30:00")
        ])
      end
    end

  end
end
