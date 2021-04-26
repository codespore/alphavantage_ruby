describe Alphavantage::NormalizeKey do
  describe '#call' do

    let(:key_a) { "Crypto Rating (FCAS)" }
    let(:key_b) { "3. fcas rating" }
    let(:key_c) { "4. Last Refreshed" }
    let(:key_d) { "Time Series FX (5min)" }
    let(:key_e) { "1a. open (CNY)" }
    let(:key_f) { "Technical Analysis: SMA" }

    it 'returns normalized key' do
      expect(described_class.new(key: key_a).call).to eq(:crypto_rating_fcas)
      expect(described_class.new(key: key_b).call).to eq(:fcas_rating)
      expect(described_class.new(key: key_c).call).to eq(:last_refreshed)
      expect(described_class.new(key: key_d).call).to eq(:time_series_fx_5min)
      expect(described_class.new(key: key_e).call).to eq(:open_cny)
      expect(described_class.new(key: key_f).call).to eq(:technical_analysis_sma)
    end

    context 'when key is date' do
      let(:key_date) { "2021-04-23" }
      it 'returns the same' do
        expect(described_class.new(key: key_date).call).to eq("2021-04-23")
      end
    end

    context 'when key is date' do
      let(:key_date_time) { "2021-04-23 21:55:00" }
      it 'returns the same' do
        expect(described_class.new(key: key_date_time).call).to eq("2021-04-23 21:55:00")
      end
    end

  end
end