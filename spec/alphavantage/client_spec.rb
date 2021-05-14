
describe Alphavantage::Client do

  describe '::get' do
    context 'error' do
      before do
        Alphavantage.configure do |config|
          config.api_key = ''
        end
      end

      let(:body) do
        "{\n    \"Error Message\": \"the parameter apikey is invalid or missing. " \
        "Please claim your free API key on (https://www.alphavantage.co/support/#api-key). " \
        "It should take less than 20 seconds.\"\n}"
      end

      before do
        stub_request(:get, "https://www.alphavantage.co/query?apikey=").
          to_return(status: 200, body: body, headers: {})
      end

      context 'json request' do
        subject { described_class.get(params: {}) }

        it 'should raise' do
          expect { subject }.to raise_error Alphavantage::Error
        end
      end

      context 'csv request' do
        subject { described_class.get(params: {}, datatype: :csv) }

        it 'should raise' do
          expect { subject }.to raise_error Alphavantage::Error
        end
      end
    end
  end
end