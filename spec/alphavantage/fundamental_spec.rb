describe Alphavantage::Fundamental do
  before do
    Alphavantage.configure do |config|
      config.api_key = 'someKey'
    end
  end

  describe '#overview' do
    subject { described_class.new(symbol: 'TSLA').overview }

    before do
      stub_request(:get, "https://www.alphavantage.co/query?apikey=someKey&function=OVERVIEW&symbol=TSLA").
        to_return(status: 200, body: file_fixture("fundamental/company_overview.json"), headers: {})
    end

    it 'returns company overview' do
      expect(subject.industry).to eq('Auto Manufacturers')
    end
  end

  describe '#earnings' do
    subject { described_class.new(symbol: 'TSLA').earnings }

    before do
      stub_request(:get, "https://www.alphavantage.co/query?apikey=someKey&function=EARNINGS&symbol=TSLA").
        to_return(status: 200, body: file_fixture("fundamental/earnings.json"), headers: {})
    end

    it 'returns company earnings' do
      expect(subject.first).to have_attributes({fiscal_date_ending: '2021-03-31', reported_eps: '0'})
    end
  end

  describe '#income_statement' do
    subject { described_class.new(symbol: 'TSLA').income_statement }

    before do
      stub_request(:get, "https://www.alphavantage.co/query?apikey=someKey&function=INCOME_STATEMENT&symbol=TSLA").
        to_return(status: 200, body: file_fixture("fundamental/income_statement.json"), headers: {})
    end

    it 'returns company income statements' do
      expect(subject.first).to have_attributes({gross_profit: '6630000000'})
    end
  end

  describe '#balance_sheet' do
    subject { described_class.new(symbol: 'TSLA').balance_sheet }

    before do
      stub_request(:get, "https://www.alphavantage.co/query?apikey=someKey&function=BALANCE_SHEET&symbol=TSLA").
        to_return(status: 200, body: file_fixture("fundamental/balance_sheet.json"), headers: {})
    end

    it 'returns company income statements' do
      expect(subject.first).to have_attributes({total_assets: '52148000000'})
    end
  end

  describe '#cash_flow' do
    subject { described_class.new(symbol: 'TSLA').cash_flow }

    before do
      stub_request(:get, "https://www.alphavantage.co/query?apikey=someKey&function=CASH_FLOW&symbol=TSLA").
        to_return(status: 200, body: file_fixture("fundamental/cash_flow.json"), headers: {})
    end

    it 'returns company income statements' do
      expect(subject.first).to have_attributes({operating_cashflow: '5943000000'})
    end
  end
end