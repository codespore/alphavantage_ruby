describe Alphavantage::Indicator do
  before do
    Alphavantage.configure do |config|
      config.api_key = 'demo'
    end
  end

  describe '#sma' do
    let(:interval)    { 'weekly' }
    let(:time_period) { 10 }
    let(:series_type) { 'open' }

    subject { described_class.new(symbol: 'TSLA', interval: interval).sma(time_period: time_period, series_type: series_type) }

    before do
      stub_request(:get, "https://www.alphavantage.co/query?function=SMA&symbol=TSLA&interval=weekly&time_period=10&series_type=open&apikey=demo").
        to_return(status: 200, body: file_fixture("indicator/sma.json"), headers: {})
    end

    it 'returns meta data' do
      expect(subject.meta_data).to have_attributes({ 
        indicator: "Simple Moving Average (SMA)"
      })
    end

    it 'returns sma' do
      expect(subject.technical_analysis_sma["2021-04-23"]).to have_attributes({
        sma: "697.8630"
      })
    end

    context 'when invalid interval given' do
      let(:interval) { 'century' }
      it 'should raise error' do
        expect { subject }.to raise_error(Alphavantage::Error, "Invalid interval given.")
      end
    end

    context 'when invalid time period given' do
      let(:time_period) { 'string' }
      it 'should raise error' do
        expect { subject }.to raise_error(Alphavantage::Error, "Invalid time period given. Must be integer.")
      end
    end

    context 'when invalid series type given' do
      let(:series_type) { 'banana' }
      it 'should raise error' do
        expect { subject }.to raise_error(Alphavantage::Error, "Invalid series type given.")
      end
    end
  end

  describe '#ema' do
    let(:interval)    { 'weekly' }
    let(:time_period) { 10 }
    let(:series_type) { 'open' }

    subject { described_class.new(symbol: 'TSLA', interval: interval).ema(time_period: time_period, series_type: series_type) }

    before do
      stub_request(:get, "https://www.alphavantage.co/query?function=EMA&symbol=TSLA&interval=weekly&time_period=10&series_type=open&apikey=demo").
        to_return(status: 200, body: file_fixture("indicator/ema.json"), headers: {})
    end

    it 'returns meta data' do
      expect(subject.meta_data).to have_attributes({ 
        indicator: "Exponential Moving Average (EMA)"
      })
    end

    it 'returns sma' do
      expect(subject.technical_analysis_ema["2021-04-23"]).to have_attributes({
        ema: "699.3560"
      })
    end

    context 'when invalid interval given' do
      let(:interval) { 'century' }
      it 'should raise error' do
        expect { subject }.to raise_error(Alphavantage::Error, "Invalid interval given.")
      end
    end

    context 'when invalid time period given' do
      let(:time_period) { 'string' }
      it 'should raise error' do
        expect { subject }.to raise_error(Alphavantage::Error, "Invalid time period given. Must be integer.")
      end
    end

    context 'when invalid series type given' do
      let(:series_type) { 'banana' }
      it 'should raise error' do
        expect { subject }.to raise_error(Alphavantage::Error, "Invalid series type given.")
      end
    end
  end
end