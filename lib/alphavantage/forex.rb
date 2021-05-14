module Alphavantage
  class Forex
    include Validations

    FUNCTIONS = {
      exchange_rates: 'CURRENCY_EXCHANGE_RATE',
      intraday: 'FX_INTRADAY',
      daily: 'FX_DAILY',
      weekly: 'FX_WEEKLY',
      monthly: 'FX_MONTHLY'
    }

    def initialize(from_symbol:,to_symbol:)
      @from_symbol = from_symbol
      @to_symbol = to_symbol
    end

    def exchange_rates
      Client.get(params: {
        function: FUNCTIONS[__method__],
        from_currency: @from_symbol,
        to_currency: @to_symbol
      }).realtime_currency_exchange_rate
    end

    def intraday(interval: '5min', outputsize: 'compact')
      Client.get(params: {
        function: FUNCTIONS[__method__],
        from_symbol: @from_symbol,
        to_symbol: @to_symbol,
        interval: validate_interval(interval),
        outputsize: validate_outputsize(outputsize)
      })
    end

    def daily(outputsize: 'compact')
      Client.get(params: {
        function: FUNCTIONS[__method__],
        from_symbol: @from_symbol,
        to_symbol: @to_symbol,
        outputsize: validate_outputsize(outputsize)
      })
    end

    def weekly
      Client.get(params: {
        function: FUNCTIONS[__callee__],
        from_symbol: @from_symbol,
        to_symbol: @to_symbol
      })
    end
    alias :monthly :weekly
  end
end