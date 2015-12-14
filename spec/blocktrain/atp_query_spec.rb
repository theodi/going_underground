module Blocktrain
  describe ATPQuery do

    it 'gets the previous station for southbound' do
      {
        blackhorse_road: 37,
        tottenham_hale: 123,
        seven_sisters: 195,
        finsbury_park: 329,
        highbury_and_islington: 893,
        kings_cross_st_pancras: 1035,
        euston: 1193,
        warren_street: 1309,
        oxford_circus: 1377,
        green_park: 1463,
        victoria: 1525,
        pimlico: 1643,
        vauxhall: 1753,
        stockwell: 1809
      }.each do |k,v|
        subject = described_class.new(from: '2015-09-01 10:00:00Z', to: '2015-09-01 11:00:00Z', station: k, direction: :southbound)
        expect(subject.station_filter).to eq(v)
      end
    end

    it 'gets the previous station for northbound' do
      {
        blackhorse_road: 206,
        tottenham_hale: 492,
        seven_sisters: 870,
        finsbury_park: 1026,
        highbury_and_islington: 1174,
        kings_cross_st_pancras: 1286,
        euston: 1362,
        warren_street: 1430,
        oxford_circus: 1496,
        green_park: 1614,
        victoria: 1746,
        pimlico: 1798,
        vauxhall: 1894,
        stockwell: 1992
      }.each do |k,v|
        subject = described_class.new(from: '2015-09-01 10:00:00Z', to: '2015-09-01 11:00:00Z', station: k, direction: :northbound)
        expect(subject.station_filter).to eq(v)
      end
    end

    it 'builds the query correctly' do
      subject = described_class.new(from: '2015-09-01 10:00:00Z', to: '2015-09-01 11:00:00Z', station: :green_park, direction: :northbound)
      expect(subject.build_query(['2E5485AW'])).to eq("memoryAddress:2E5485AW AND value:1614")
    end

  end
end
