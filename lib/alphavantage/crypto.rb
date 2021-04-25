module Alphavantage
  class Crypto
    include Validations

    FUNCTIONS = {
      health_index: 'CRYPTO_RATING',
      intraday: 'CRYPTO_INTRADAY',
      daily: 'CRYPTO_DAILY',
      weekly: 'CRYPTO_WEEKLY',
      monthly: 'CRYPTO_MONTHLY'
    }

    def self.health_index(symbol:)
      Client.get(params: { 
        function: self::FUNCTIONS[__method__],
        symbol: symbol
      }).crypto_rating_fcas
    end

  end
end