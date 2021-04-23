
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
end