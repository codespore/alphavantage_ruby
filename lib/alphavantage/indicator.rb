module Alphavantage
  class Indicator
    include Validations

    def initialize(symbol:,interval:)
      @symbol = symbol
      @interval = interval
    end

    def sma(time_period:,series_type:)
      Client.get(params: { 
        function: __callee__.upcase,
        symbol: @symbol,
        interval: validate_indicator_interval(@interval),
        time_period: validate_time_period(time_period),
        series_type: validate_series_type(series_type)
      })
    end
    alias :ema      :sma
    alias :wma      :sma
    alias :dema     :sma
    alias :tema     :sma
    alias :trima    :sma
    alias :kama     :sma
    alias :mama     :sma
    alias :t3       :sma
    alias :rsi      :sma
    alias :mom      :sma
    alias :cmo      :sma
    alias :roc      :sma
    alias :rocr     :sma
    alias :trix     :sma
    alias :midpoint :sma

    def vwap
      Client.get(params: { 
        function: __callee__.upcase,
        symbol: @symbol,
        interval: [:bop,:trange,:ad,:obv].include?(__callee__) ? validate_indicator_interval(@interval) : validate_interval(@interval)
      })
    end
    alias :bop      :vwap
    alias :trange   :vwap
    alias :ad       :vwap
    alias :obv      :vwap

  end
end