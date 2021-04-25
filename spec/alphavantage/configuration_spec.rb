describe Alphavantage::Configuration do
  after(:each) do
    described_class.instance_variable_set('@configuration', nil)
  end

  it 'should set the configuration with a config block' do
    Alphavantage.configure do |config|
      config.api_key = 'someKey'
    end

    expect(Alphavantage.configuration.api_key).to eq('someKey')
  end
end