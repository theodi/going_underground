module Blocktrain
  describe Lookups do

    it 'gets lookups from redis' do
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

      aliases = {
        'thing_1' => '1',
        'thing_2' => '2',
        'thing_3' => '3',
        'thing_4' => nil
      }

      expect_any_instance_of(Redis).to receive(:get).with('lookups') {
        lookups.to_json
      }
      expect_any_instance_of(Redis).to receive(:get).with('aliases') {
        aliases.to_json
      }

      Blocktrain::Lookups.instance.fetch_from_redis

      expect(Blocktrain::Lookups.instance.lookups).to eq(lookups)
      expect(Blocktrain::Lookups.instance.aliases).to eq(aliases)
    end

  end
end
