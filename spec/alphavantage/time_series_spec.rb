
describe Alphavantage::TimeSeries do
  before do
    Alphavantage.configure do |config|
      config.api_key = 'someKey'
    end
  end

  describe '.search' do
    subject { described_class.search(keywords: 'Tesla') }

    before do
      stub_request(:get, "https://www.alphavantage.co/query?apikey=someKey&function=SYMBOL_SEARCH&keywords=Tesla").
        to_return(status: 200, body: file_fixture("time_series/search.json"), headers: {})
    end

    it 'returns search result' do
      expect(subject.map(&:symbol)).to match_array(%w{ TL0.DEX TL0.FRK TSLA34.SAO TSLA TXLZF })
    end
  end

  describe '#quote' do
    subject { described_class.new(symbol: 'TSLA').quote }

    before do
      stub_request(:get, "https://www.alphavantage.co/query?apikey=someKey&function=GLOBAL_QUOTE&symbol=TSLA").
        to_return(status: 200, body: file_fixture("time_series/quote.json"), headers: {})
    end

    it 'returns quote result' do
      expect(subject).to have_attributes({
        change: "9.7100",
        symbol: "TSLA",
        change_percent: "1.3492%",
        high: "737.3600",
        latest_trading_day: "2021-04-23",
        low: "715.4600",
        previous_close: "719.6900",
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
      stub_request(:get, "https://www.alphavantage.co/query?apikey=someKey&function=TIME_SERIES_MONTHLY&symbol=TSLA").
        to_return(status: 200, body: file_fixture("time_series/monthly.json"), headers: {})
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
        stub_request(:get, "https://www.alphavantage.co/query?apikey=someKey&function=TIME_SERIES_MONTHLY_ADJUSTED&symbol=TSLA").
          to_return(status: 200, body: file_fixture("time_series/monthly_adjusted.json"), headers: {})
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
          adjusted_close: "729.4000",
          dividend_amount: "0.0000"
        })
        expect(subject.monthly_adjusted_time_series["2021-04-23"].open).to eq("688.3700")
      end
    end
  end

  describe '#weekly' do
    subject { described_class.new(symbol: 'TSLA').weekly }
    before do
      stub_request(:get, "https://www.alphavantage.co/query?apikey=someKey&function=TIME_SERIES_WEEKLY&symbol=TSLA").
        to_return(status: 200, body: file_fixture("time_series/weekly.json"), headers: {})
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
        stub_request(:get, "https://www.alphavantage.co/query?apikey=someKey&function=TIME_SERIES_WEEKLY_ADJUSTED&symbol=TSLA").
          to_return(status: 200, body: file_fixture("time_series/weekly_adjusted.json"), headers: {})
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
          adjusted_close: "729.4000",
          dividend_amount: "0.0000"
        })
        expect(subject.weekly_adjusted_time_series["2021-04-23"].open).to eq("719.6000")
      end
    end
  end

  describe '#daily' do
    subject { described_class.new(symbol: 'TSLA').daily }
    before do
      stub_request(:get, "https://www.alphavantage.co/query?apikey=someKey&function=TIME_SERIES_DAILY&outputsize=compact&symbol=TSLA").
        to_return(status: 200, body: file_fixture("time_series/daily.json"), headers: {})
    end

    it 'returns meta data' do
      expect(subject.meta_data).to have_attributes({
        information: "Daily Prices (open, high, low, close) and Volumes",
        last_refreshed: "2021-04-23",
        symbol: "TSLA",
        output_size: "Compact",
        time_zone: "US/Eastern"
      })
    end

    it 'returns daily time series' do
      expect(subject.time_series_daily["2021-04-23"]).to have_attributes({
        close: "729.4000",
        high: "737.3600",
        low: "715.4600",
        volume: "27703323"
      })
      expect(subject.time_series_daily["2021-04-23"].open).to eq("719.8000")
    end

    context 'when invalid outputsize given' do
      subject { described_class.new(symbol: 'TSLA').daily(outputsize: 'invalid') }
      it 'should raise error' do
        expect { subject }.to raise_error(Alphavantage::Error, "Invalid outputsize given.")
      end
    end

    context 'when adjusted' do
      subject { described_class.new(symbol: 'TSLA').daily(adjusted: true) }
      before do
        stub_request(:get, "https://www.alphavantage.co/query?apikey=someKey&function=TIME_SERIES_DAILY_ADJUSTED&outputsize=compact&symbol=TSLA").
          to_return(status: 200, body: file_fixture("time_series/daily_adjusted.json"), headers: {})
      end

      it 'returns meta data' do
        expect(subject.meta_data).to have_attributes({
          information: "Daily Time Series with Splits and Dividend Events",
          last_refreshed: "2021-04-23",
          symbol: "TSLA",
          output_size: "Compact",
          time_zone: "US/Eastern"
        })
      end

      it 'returns daily adjusted time series' do
        expect(subject.time_series_daily["2021-04-23"]).to have_attributes({
          close: "729.4",
          high: "737.36",
          low: "715.46",
          volume: "27703323",
          adjusted_close: "729.4",
          dividend_amount: "0.0000",
          split_coefficient: "1.0"
        })
        expect(subject.time_series_daily["2021-04-23"].open).to eq("719.8")
      end
    end
  end

  describe '#intraday' do
    context 'datatype: json' do
      subject { described_class.new(symbol: 'TSLA').intraday }
      before do
        stub_request(:get, "https://www.alphavantage.co/query?adjusted=true&apikey=someKey&datatype=json&function=TIME_SERIES_INTRADAY&interval=5min&outputsize=compact&symbol=TSLA").
          to_return(status: 200, body: file_fixture("time_series/intraday.json"), headers: {})
      end

      it 'returns meta data' do
        expect(subject.meta_data).to have_attributes({
          information: "Intraday (5min) open, high, low, close prices and volume",
          last_refreshed: "2021-04-23 20:00:00",
          symbol: "TSLA",
          output_size: "Compact",
          time_zone: "US/Eastern"
        })
      end

      it 'returns daily time series' do
        expect(subject.time_series_5min["2021-04-23 20:00:00"]).to have_attributes({
          close: "730.1000",
          high: "730.5000",
          low: "730.1000",
          volume: "5637"
        })
        expect(subject.time_series_5min["2021-04-23 20:00:00"].open).to eq("730.2500")
      end

      context 'when invalid outputsize given' do
        subject { described_class.new(symbol: 'TSLA').intraday(outputsize: 'invalid') }
        it 'should raise error' do
          expect { subject }.to raise_error(Alphavantage::Error, "Invalid outputsize given.")
        end
      end

      context 'when invalid interval given' do
        subject { described_class.new(symbol: 'TSLA').intraday(interval: '100min') }
        it 'should raise error' do
          expect { subject }.to raise_error(Alphavantage::Error, "Invalid interval given.")
        end
      end

      context 'when invalid datatype given' do
        subject { described_class.new(symbol: 'TSLA').intraday(datatype: 'wrong') }
        it 'should raise error' do
          expect { subject }.to raise_error(Alphavantage::Error, "Invalid data type given.")
        end
      end
    end

    context 'datatype: csv' do
      subject { described_class.new(symbol: 'TSLA').intraday datatype: 'csv' }

      before do
        stub_request(:get, "https://www.alphavantage.co/query?adjusted=true&apikey=someKey&datatype=csv&function=TIME_SERIES_INTRADAY&interval=5min&outputsize=compact&symbol=TSLA").
          to_return(status: 200, body: file_fixture("time_series/intraday.csv"), headers: {})
      end

      # do not need to test further, cos we are testing out fixture
      it 'returns CSV caption' do
        expect(subject.first).to match_array %w[timestamp open high low close volume]
      end
    end
  end

  describe '#intraday_extended_history' do
    subject { described_class.new(symbol: 'TSLA').intraday_extended_history }

    before do
      stub_request(:get, "https://www.alphavantage.co/query?adjusted=true&apikey=someKey&function=TIME_SERIES_INTRADAY_EXTENDED&interval=5min&slice=year1month1&symbol=TSLA").
        to_return(status: 200, body: file_fixture("time_series/intraday_extended_history.csv"), headers: {})
    end

    # do not need to test further, cos we are testing out fixture
    it 'returns CSV caption' do
      expect(subject.first).to match_array %w[time open high low close volume]
    end
  end
end