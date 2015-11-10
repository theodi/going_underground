module Blocktrain
  describe Lookups do

    it 'autodetects all available signals', :vcr do
      expect(described_class.instance.lookups['@.MWT.M_T3_1.MRV_TrnSpd_1.TON_4.MRV_Xv_Trn']).to eq '2E491EEW'
    end

    it 'has useful aliases for obscure signal names', :vcr do
      expect(described_class.instance.lookups['train_speed']).to eq '2E491EEW'
    end

  end
end
