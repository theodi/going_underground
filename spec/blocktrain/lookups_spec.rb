module Blocktrain
  describe Lookups do
    subject(:instance) { described_class.instance }

    it 'removes incorrect signal parts' do
      {
        '@.MWT.CT_CI_T2_1.UCOD4_I_MLC20.CI_COP_XI_Ln' => '@.MWT.CT_CI_T2_1.CI_COP_XI_Ln',
        '@.MWT.CT_CI_T2_1.UCOD4_I_MLC20.CI_COP_XU_Ln' => '@.MWT.CT_CI_T2_1.CI_COP_XU_Ln',
        '@.MWT.P_T2_1.TOF_5.PII_DCUM1_XF_TrBrAch' => '@.MWT.P_T2_1.PII_DCUM1_XF_TrBrAch',
        '@.MWT.M_T3_1.MRV_TrnSpd_1.TON_4.MRV_Xv_Trn' => '@.MWT.M_T3_1.MRV_TrnSpd_1.MRV_Xv_Trn',
        '@.MWT.P_T3_1.PSV_ShoeLoss_1.WITHIN_4.PII_DCUM1_XF_BrAvl' => '@.MWT.P_T3_1.PSV_ShoeLoss_1.PII_DCUM1_XF_BrAvl',
        '@.MWT.M_T2_1.TOF_1.MRV_W_PwmRef2' => '@.MWT.M_T2_1.MRV_W_PwmRef2',
        '@.MWT.M_T2_1.TOF_1.MRV_W_PwmRef1' => '@.MWT.M_T2_1.MRV_W_PwmRef1',
        '@.MWT.M_T2_1.TOF_1.MRV_W_TrBrEffRef' => '@.MWT.M_T2_1.MRV_W_TrBrEffRef',
        '@.MWT.CT_CI_T3_1.UCOD4_I_MLC32.CI_BGW_Wp_BcPrsCarBBgA' => '@.MWT.CT_CI_T3_1.CI_BGW_Wp_BcPrsCarBBgA',
        '@.MWT.CT_CI_T3_1.UCOD4_I_MLC32.CI_BGW_Wp_BcPrsCarBBgD' => '@.MWT.CT_CI_T3_1.CI_BGW_Wp_BcPrsCarBBgD'
      }.each do |k,v|
        expected = instance.send(:remove_cruft, k)
        expect(expected).to eq(v)
      end
    end

    it 'autodetects all available signals', :vcr do
      expect(instance.lookups['@.MWT.M_T3_1.MRV_TrnSpd_1.MRV_Xv_Trn']).to eq '2E491EEW'
    end

    it 'has useful aliases for obscure signal names', :vcr do
      expect(instance.lookups['train_speed']).to eq '2E491EEW'
    end

    it 'returns a list with only aliases', :vcr do
      expect(instance.aliases.count).to eq 78
      expect(instance.aliases['train_speed']).to eq '2E491EEW'
    end

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

      instance.fetch_from_redis

      expect(instance.lookups).to eq(lookups)
      expect(instance.aliases).to eq(aliases)
    end
  end
end
