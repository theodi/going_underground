module SirHandel
  describe Tasks do
    it 'stores cromulised dates in Redis', :vcr do
      datas = "{\"start\":\"2015-12-01T00:00:00+00:00\",\"end\":\"2016-02-05T00:00:00+00:00\"}"
      expect_any_instance_of(Redis).to receive(:set).with('cromulent-dates', datas)

      described_class.cromulise
    end

  end
end
