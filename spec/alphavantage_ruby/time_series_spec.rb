
describe AlphavantageRuby::TimeSeries do
  before do
    AlphavantageRuby.configure do |config|
      config.api_key = 'someKey'
    end
  end

  describe '.search' do
    subject { described_class.search(keywords: 'Tesla') }

    before do
      stub_request(:get, "https://www.alphavantage.co/query?apikey=someKey&datatype=json&function=SYMBOL_SEARCH&keywords=Tesla").
        to_return(status: 200, body: file_fixture("search.json"), headers: {})
    end

    it 'returns search result' do
      expect(subject.map(&:symbol)).to match_array(%w{ TL0.DEX TL0.FRK TSLA34.SAO TSLA TXLZF })
    end
  end

  describe '#quote' do
    subject { described_class.new(symbol: 'TSLA').quote }

    before do
      stub_request(:get, "https://www.alphavantage.co/query?apikey=someKey&datatype=json&function=GLOBAL_QUOTES&symbol=TSLA").
        to_return(status: 200, body: file_fixture("quote.json"), headers: {})
    end

    it 'returns quote result' do
      expect(subject).to have_attributes({
        change: "9.7100",
        symbol: "TSLA",
        changepercent: "1.3492%",
        high: "737.3600",
        latesttradingday: "2021-04-23",
        low: "715.4600",
        previousclose: "719.6900",
        price: "729.4000",
        volume: "27879033"
      })

      # For some reason have_attributes is calling the `open` method on subject raising ArgumentError
      expect(subject.open).to eq("719.8000")
    end
  end

  describe '#monthly' do
    subject { described_class.new(symbol: 'TSLA').monthly }
    before do
      stub_request(:get, "https://www.alphavantage.co/query?apikey=someKey&datatype=json&function=TIME_SERIES_MONTHLY&symbol=TSLA").
        to_return(status: 200, body: file_fixture("monthly.json"), headers: {})
    end
    
    it 'returns meta data' do
      expect(subject.meta_data).to have_attributes({ 
        information: "Monthly Prices (open, high, low, close) and Volumes",
        last_refreshed: "2021-04-23",
        symbol: "TSLA",
        time_zone: "US/Eastern"
      })
    end

    it 'returns monthly time series' do
      expect(subject.monthly_time_series["2021-04-23"]).to have_attributes({
        close: "729.4000",
        high: "780.7900",
        low: "659.4200",
        volume: "525522527"
      })
      expect(subject.monthly_time_series["2021-04-23"].open).to eq("688.3700")
    end

    context 'when adjusted' do
      subject { described_class.new(symbol: 'TSLA').monthly(adjusted: true) }
      before do
        stub_request(:get, "https://www.alphavantage.co/query?apikey=someKey&datatype=json&function=TIME_SERIES_MONTHLY_ADJUSTED&symbol=TSLA").
          to_return(status: 200, body: file_fixture("monthly_adjusted.json"), headers: {})
      end

      it 'returns meta data' do
        expect(subject.meta_data).to have_attributes({ 
          information: "Monthly Adjusted Prices and Volumes",
          last_refreshed: "2021-04-23",
          symbol: "TSLA",
          time_zone: "US/Eastern"
        })
      end

      it 'returns monthly adjusted time series' do
        expect(subject.monthly_adjusted_time_series["2021-04-23"]).to have_attributes({
          close: "729.4000",
          high: "780.7900",
          low: "659.4200",
          volume: "525522527",
          adjustedclose: "729.4000",
          dividendamount: "0.0000"
        })
        expect(subject.monthly_adjusted_time_series["2021-04-23"].open).to eq("688.3700")
      end
    end
  end

  describe '#weekly' do
    subject { described_class.new(symbol: 'TSLA').weekly }
    before do
      stub_request(:get, "https://www.alphavantage.co/query?apikey=someKey&datatype=json&function=TIME_SERIES_WEEKLY&symbol=TSLA").
        to_return(status: 200, body: file_fixture("weekly.json"), headers: {})
    end
    
    it 'returns meta data' do
      expect(subject.meta_data).to have_attributes({ 
        information: "Weekly Prices (open, high, low, close) and Volumes",
        last_refreshed: "2021-04-23",
        symbol: "TSLA",
        time_zone: "US/Eastern"
      })
    end

    it 'returns weekly time series' do
      expect(subject.weekly_time_series["2021-04-23"]).to have_attributes({
        close: "729.4000",
        high: "753.7700",
        low: "691.8001",
        volume: "169804356"
      })
      expect(subject.weekly_time_series["2021-04-23"].open).to eq("719.6000")
    end

    context 'when adjusted' do
      subject { described_class.new(symbol: 'TSLA').weekly(adjusted: true) }
      before do
        stub_request(:get, "https://www.alphavantage.co/query?apikey=someKey&datatype=json&function=TIME_SERIES_WEEKLY_ADJUSTED&symbol=TSLA").
          to_return(status: 200, body: file_fixture("weekly_adjusted.json"), headers: {})
      end

      it 'returns meta data' do
        expect(subject.meta_data).to have_attributes({ 
          information: "Weekly Adjusted Prices and Volumes",
          last_refreshed: "2021-04-23",
          symbol: "TSLA",
          time_zone: "US/Eastern"
        })
      end

      it 'returns weekly adjusted time series' do
        expect(subject.weekly_adjusted_time_series["2021-04-23"]).to have_attributes({
          close: "729.4000",
          high: "753.7700",
          low: "691.8001",
          volume: "169804356",
          adjustedclose: "729.4000",
          dividendamount: "0.0000"
        })
        expect(subject.weekly_adjusted_time_series["2021-04-23"].open).to eq("719.6000")
      end
    end
  end
end