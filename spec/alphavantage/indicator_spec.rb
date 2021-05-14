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
        expect { subject }.to raise_error(Alphavantage::Error, /Invalid interval given./)
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
        expect { subject }.to raise_error(Alphavantage::Error, /Invalid series type given./)
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

    it 'returns ema' do
      expect(subject.technical_analysis_ema["2021-04-23"]).to have_attributes({
        ema: "699.3560"
      })
    end

    context 'when invalid interval given' do
      let(:interval) { 'century' }
      it 'should raise error' do
        expect { subject }.to raise_error(Alphavantage::Error, /Invalid interval given./)
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
        expect { subject }.to raise_error(Alphavantage::Error, /Invalid series type given./)
      end
    end
  end

  describe '#vwap' do
    let(:interval)    { '5min' }
    subject { described_class.new(symbol: 'IBM', interval: interval).vwap }

    before do
      stub_request(:get, "https://www.alphavantage.co/query?function=VWAP&symbol=IBM&interval=#{interval}&apikey=demo").
        to_return(status: 200, body: file_fixture("indicator/vwap.json"), headers: {})
    end

    it 'returns meta data' do
      expect(subject.meta_data).to have_attributes({
        indicator: "Volume Weighted Average Price (VWAP)"
      })
    end

    it 'returns vwap' do
      expect(subject.technical_analysis_vwap["2021-04-30 20:00"]).to have_attributes({
        vwap: "141.5264"
      })
    end
  end

  describe '#bop' do
    let(:interval) { 'weekly' }
    subject { described_class.new(symbol: 'IBM', interval: interval).bop }

    before do
      stub_request(:get, "https://www.alphavantage.co/query?function=BOP&symbol=IBM&interval=#{interval}&apikey=demo").
        to_return(status: 200, body: file_fixture("indicator/bop.json"), headers: {})
    end

    it 'returns meta data' do
      expect(subject.meta_data).to have_attributes({
        indicator: "Balance Of Power (BOP)"
      })
    end

    it 'returns bop' do
      expect(subject.technical_analysis_bop["2021-04-30"]).to have_attributes({
        bop: "-0.5549"
      })
    end
  end

  describe '#macd' do
    let(:interval)      { 'weekly' }
    let(:series_type)   { 'open' }
    let(:fastperiod)    { '12' }
    let(:slowperiod)    { '26' }
    let(:signalperiod)  { '9' }

    subject { described_class.new(symbol: 'IBM', interval: interval).macd(series_type: series_type, fastperiod: fastperiod, slowperiod: slowperiod, signalperiod: signalperiod) }

    before do
      stub_request(:get, "https://www.alphavantage.co/query?function=MACD&symbol=IBM&interval=#{interval}&series_type=#{series_type}&fastperiod=#{fastperiod}&slowperiod=#{slowperiod}&signalperiod=#{signalperiod}&apikey=demo").
        to_return(status: 200, body: file_fixture("indicator/macd.json"), headers: {})
    end

    it 'returns meta data' do
      expect(subject.meta_data).to have_attributes({
        indicator: "Moving Average Convergence/Divergence (MACD)"
      })
    end

    it 'returns macd' do
      expect(subject.technical_analysis_macd["2021-04-30"]).to have_attributes({
        macd: "3.5648"
      })
    end
  end

  describe '#stoch' do
    let(:interval)     { 'weekly' }
    let(:fastkperiod)  { '5' }
    let(:slowkperiod)  { '3' }
    let(:slowdperiod)  { '3' }
    let(:slowkmatype)  { 'ema' }
    let(:slowdmatype)  { 'kama' }

    subject do
      described_class.new(symbol: 'IBM', interval: interval).
        stoch(
          fastkperiod: fastkperiod,
          slowkperiod: slowkperiod,
          slowdperiod: slowdperiod,
          slowkmatype: slowkmatype,
          slowdmatype: slowdmatype
        )
    end

    before do
      stub_request(:get, "https://www.alphavantage.co/query?apikey=demo&fastkperiod=5&function=STOCH&interval=weekly&slowdmatype=7&slowdperiod=3&slowkmatype=1&slowkperiod=3&symbol=IBM").
        to_return(status: 200, body: file_fixture("indicator/stoch.json"), headers: {})
    end

    it 'returns meta data' do
      expect(subject.meta_data).to have_attributes({
        indicator: "Stochastic (STOCH)"
      })
    end

    it 'returns stoch' do
      expect(subject.technical_analysis_stoch["2021-04-30"]).to have_attributes({
        slow_k: "38.7700",
        slow_d: "50.6307"
      })
    end
  end

end