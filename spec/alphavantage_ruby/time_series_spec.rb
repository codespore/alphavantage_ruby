
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
end