module SirHandel
  describe Tasks do
    it 'stores cromulised dates in Redis', :vcr do
      datas = "{\"start\":\"2015-08-28T02:00:00+00:00\",\"end\":\"2015-09-28T23:00:00+00:00\"}"
      expect_any_instance_of(Redis).to receive(:set).with('cromulent-dates', datas)

      described_class.cromulise
    end

  end
end
