module Blocktrain
  describe Lookups do

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
        expected = described_class.instance.send(:remove_cruft, k)
        expect(expected).to eq(v)
      end
    end

    it 'autodetects all available signals', :vcr do
      expect(described_class.instance.lookups['@.MWT.M_T3_1.MRV_TrnSpd_1.MRV_Xv_Trn']).to eq '2E491EEW'
    end

    it 'has useful aliases for obscure signal names', :vcr do
      expect(described_class.instance.lookups['train_speed']).to eq '2E491EEW'
    end

  end
end
