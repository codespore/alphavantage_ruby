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
      expect(subject.fcas_rating).to eq('Attractive')
    end
  end

  describe '#intraday' do
    subject { described_class.new(symbol: 'ETH', market: 'USD').intraday(interval: '5min') }

    before do
      stub_request(:get, "https://www.alphavantage.co/query?function=CRYPTO_INTRADAY&symbol=ETH&market=USD&interval=5min&apikey=demo").
        to_return(status: 200, body: file_fixture("crypto/intraday.json"), headers: {})
    end

    it 'returns meta data' do
      expect(subject.meta_data).to have_attributes({
        information: "Crypto Intraday (5min) Time Series"
      })
    end

    it 'returns time series' do
      expect(subject.time_series_crypto_5min["2021-04-25 15:45:00"]).to have_attributes({
        close: "2340.22000",
        high: "2342.00000",
        low: "2334.42000",
        volume: 1367
      })
      expect(subject.time_series_crypto_5min["2021-04-25 15:45:00"].open).to eq("2339.76000")
    end

    context 'when invalid interval given' do
      subject { described_class.new(symbol: 'ETH', market: 'USD').intraday(interval: '100min') }
      it 'should raise error' do
        expect { subject }.to raise_error(Alphavantage::Error, /Invalid interval given./)
      end
    end
  end

  describe '#daily' do
    subject { described_class.new(symbol: 'BTC', market: 'CNY').daily }
    before do
      stub_request(:get, "https://www.alphavantage.co/query?function=DIGITAL_CURRENCY_DAILY&symbol=BTC&market=CNY&apikey=demo").
        to_return(status: 200, body: file_fixture("crypto/daily.json"), headers: {})
    end
    it 'returns meta data' do
      expect(subject.meta_data).to have_attributes({
        information: "Daily Prices and Volumes for Digital Currency"
      })
    end
    it 'returns time series' do
      expect(subject.time_series_digital_currency_daily["2021-04-25"]).to have_attributes({
        open_cny: "325140.79734400"
      })
    end
  end

  describe '#weekly' do
    subject { described_class.new(symbol: 'BTC', market: 'CNY').weekly }
    before do
      stub_request(:get, "https://www.alphavantage.co/query?function=DIGITAL_CURRENCY_WEEKLY&symbol=BTC&market=CNY&apikey=demo").
        to_return(status: 200, body: file_fixture("crypto/weekly.json"), headers: {})
    end
    it 'returns meta data' do
      expect(subject.meta_data).to have_attributes({
        information: "Weekly Prices and Volumes for Digital Currency"
      })
    end
    it 'returns time series' do
      expect(subject.time_series_digital_currency_weekly["2021-04-25"]).to have_attributes({
        open_cny: "364784.15496600"
      })
    end
  end

  describe '#monthly' do
    subject { described_class.new(symbol: 'BTC', market: 'CNY').monthly }
    before do
      stub_request(:get, "https://www.alphavantage.co/query?function=DIGITAL_CURRENCY_MONTHLY&symbol=BTC&market=CNY&apikey=demo").
        to_return(status: 200, body: file_fixture("crypto/monthly.json"), headers: {})
    end
    it 'returns meta data' do
      expect(subject.meta_data).to have_attributes({
        information: "Monthly Prices and Volumes for Digital Currency"
      })
    end
    it 'returns time series' do
      expect(subject.time_series_digital_currency_monthly["2021-04-25"]).to have_attributes({
        open_cny: "381606.77583600"
      })
    end
  end
end