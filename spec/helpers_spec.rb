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

  end
end
