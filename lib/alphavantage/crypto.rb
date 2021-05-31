module Alphavantage
  class Crypto
    include Validations

    FUNCTIONS = {
      health_index: 'CRYPTO_RATING',
      intraday: 'CRYPTO_INTRADAY',
      daily: 'DIGITAL_CURRENCY_DAILY',
      weekly: 'DIGITAL_CURRENCY_WEEKLY',
      monthly: 'DIGITAL_CURRENCY_MONTHLY'
    }

    def self.health_index(symbol:)
      Client.get(params: {
        function: self::FUNCTIONS[__method__],
        symbol: symbol
      }).crypto_rating_fcas
    end

    def initialize(symbol:,market:)
      @symbol = symbol
      @market = market
    end

    def intraday(interval: '5min')
      Client.get(params: {
        function: FUNCTIONS[__method__],
        symbol: @symbol,
        market: @market,
        interval: validate_interval(interval)
      })
    end

    def daily
      Client.get(params: {
        function: FUNCTIONS[__callee__],
        symbol: @symbol,
        market: @market
      })
    end
    alias :weekly :daily
    alias :monthly :daily

  end
end