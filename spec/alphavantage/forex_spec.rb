describe Alphavantage::Forex do
  before do
    Alphavantage.configure do |config|
      config.api_key = 'demo'
    end
  end

  describe '#exchange_rates' do
    subject { described_class.new(from_symbol: 'USD', to_symbol: 'JPY').exchange_rates }

    before do
      stub_request(:get, "https://www.alphavantage.co/query?apikey=demo&from_currency=USD&function=CURRENCY_EXCHANGE_RATE&to_currency=JPY").
        to_return(status: 200, body: file_fixture("forex/exchange_rates.json"), headers: {})
    end

    it 'returns exchange rates' do
      expect(subject.exchange_rate).to eq('107.86500000')
    end
  end

  describe '#intraday' do
    subject { described_class.new(from_symbol: 'EUR', to_symbol: 'USD').intraday }

    before do
      stub_request(:get, "https://www.alphavantage.co/query?apikey=demo&from_symbol=EUR&function=FX_INTRADAY&interval=5min&outputsize=compact&to_symbol=USD").
        to_return(status: 200, body: file_fixture("forex/intraday.json"), headers: {})
    end

    it 'returns meta data' do
      expect(subject.meta_data).to have_attributes({
        information: "FX Intraday (5min) Time Series",
        from_symbol: "EUR",
        to_symbol: "USD",
        last_refreshed: "2021-04-23 21:55:00",
        interval: "5min",
        output_size: "Compact",
        time_zone: "UTC"
      })
    end

    it 'returns time series' do
      expect(subject.time_series_fx5min['2021-04-23 21:55:00'].close).to eq('1.20965')
    end
  end

  describe '#daily' do
    subject { described_class.new(from_symbol: 'EUR', to_symbol: 'USD').daily }

    before do
      stub_request(:get, "https://www.alphavantage.co/query?apikey=demo&from_symbol=EUR&function=FX_DAILY&outputsize=compact&to_symbol=USD").
        to_return(status: 200, body: file_fixture("forex/daily.json"), headers: {})
    end

    it 'returns meta data' do
      expect(subject.meta_data).to have_attributes({
        information: "Forex Daily Prices (open, high, low, close)",
        from_symbol: "EUR",
        to_symbol: "USD",
        last_refreshed: "2021-04-23 21:55:00",
        output_size: "Compact",
        time_zone: "UTC"
      })
    end

    it 'returns time series' do
      expect(subject.time_series_fx_daily['2021-04-23'].close).to eq('1.20965')
    end
  end

  describe '#weekly' do
    subject { described_class.new(from_symbol: 'EUR', to_symbol: 'USD').weekly }

    before do
      stub_request(:get, "https://www.alphavantage.co/query?apikey=demo&from_symbol=EUR&function=FX_WEEKLY&to_symbol=USD").
        to_return(status: 200, body: file_fixture("forex/weekly.json"), headers: {})
    end

    it 'returns meta data' do
      expect(subject.meta_data).to have_attributes({
        information: "Forex Weekly Prices (open, high, low, close)",
        from_symbol: "EUR",
        to_symbol: "USD",
        last_refreshed: "2021-04-23 21:55:00",
        time_zone: "UTC"
      })
    end

    it 'returns time series' do
      expect(subject.time_series_fx_weekly['2021-04-23'].close).to eq('1.20965')
    end
  end

  describe '#monthly' do
    subject { described_class.new(from_symbol: 'EUR', to_symbol: 'USD').monthly }

    before do
      stub_request(:get, "https://www.alphavantage.co/query?apikey=demo&from_symbol=EUR&function=FX_MONTHLY&to_symbol=USD").
        to_return(status: 200, body: file_fixture("forex/monthly.json"), headers: {})
    end

    it 'returns meta data' do
      expect(subject.meta_data).to have_attributes({
        information: "Forex Monthly Prices (open, high, low, close)",
        from_symbol: "EUR",
        to_symbol: "USD",
        last_refreshed: "2021-04-23 21:55:00",
        time_zone: "UTC"
      })
    end

    it 'returns time series' do
      expect(subject.time_series_fx_monthly['2021-04-23'].close).to eq('1.20965')
    end
  end
end