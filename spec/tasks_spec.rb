module SirHandel
  describe Tasks do
    it 'stores cromulised dates in Redis', :vcr do
      datas = "{\"start\":\"2015-08-28T02:00:00+00:00\",\"end\":\"2015-09-28T23:00:00+00:00\"}"
      expect_any_instance_of(Redis).to receive(:set).with('cromulent-dates', datas)

      described_class.cromulise
    end

    it 'stores the lookups in redis' do
      lookups = {
        'lookup_1' => '1',
        'lookup_2' => '2',
        'lookup_3' => '3',
        'lookup_4' => nil,
        'thing_1' => '1',
        'thing_2' => '2',
        'thing_3' => '3',
        'thing_4' => nil
      }

      expect(Blocktrain::Lookups.instance).to receive(:lookups) { lookups }

      expect_any_instance_of(Redis).to receive(:set).with('lookups', lookups.to_json).once

      described_class.get_lookups
    end

    it 'stores the aliases in redis' do
      aliases = {
        'thing_1' => '1',
        'thing_2' => '2',
        'thing_3' => '3',
        'thing_4' => nil
      }

      expect(Blocktrain::Lookups.instance).to receive(:aliases) { aliases }

      expect_any_instance_of(Redis).to receive(:set).with('aliases', aliases.to_json).once

      described_class.get_aliases
    end

  end
end
