describe AlphavantageRuby::Configuration do
  after(:each) do
    described_class.instance_variable_set('@configuration', nil)
  end

  it 'should set the configuration with a config block' do
    AlphavantageRuby.configure do |config|
      config.api_key = 'someKey'
    end

    expect(AlphavantageRuby.configuration.api_key).to eq('someKey')
  end
end