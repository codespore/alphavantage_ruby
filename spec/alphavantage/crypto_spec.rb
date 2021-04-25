describe Alphavantage::Crypto do
  before do
    Alphavantage.configure do |config|
      config.api_key = 'demo'
    end
  end

  describe '.health_index' do
    subject { described_class.health_index(symbol: 'BTC') }

    before do
      stub_request(:get, "https://www.alphavantage.co/query?function=CRYPTO_RATING&symbol=BTC&apikey=demo").
        to_return(status: 200, body: file_fixture("crypto/health_index.json"), headers: {})
    end

    it 'returns health index data' do
      expect(subject.fcasrating).to eq('Attractive')
    end
  end
end