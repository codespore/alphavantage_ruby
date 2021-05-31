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
        time_period: validate_integer(label: 'time period', value: time_period),
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

    def macd(series_type:, fastperiod: 12, slowperiod: 26, signalperiod: 9)
      Client.get(params: {
        function: __callee__.upcase,
        symbol: @symbol,
        interval: validate_indicator_interval(@interval),
        series_type: validate_series_type(series_type),
        fastperiod: validate_integer(label: 'fastperiod', value: fastperiod),
        slowperiod: validate_integer(label: 'slowperiod', value: slowperiod),
        signalperiod: validate_integer(label: 'signalperiod', value: signalperiod)
      })
    end

    MOVING_AVERAGE_TYPES = {
      sma: 0,
      ema: 1,
      wma: 2,
      dema: 3,
      tema: 4,
      trima: 5,
      t3: 6,
      kama: 7,
      mama: 8
    }

    def macdext(
      series_type:,
      fastperiod: 12,
      slowperiod: 26,
      signalperiod: 9,
      fastmatype: 'sma',
      slowmatype: 'sma',
      signalmatype: 'sma'
    )
      Client.get(params: {
        function: __callee__.upcase,
        symbol: @symbol,
        interval: validate_indicator_interval(@interval),
        series_type: validate_series_type(series_type),
        fastperiod: validate_integer(label: 'fastperiod', value: fastperiod),
        slowperiod: validate_integer(label: 'slowperiod', value: slowperiod),
        signalperiod: validate_integer(label: 'signalperiod', value: signalperiod),
        fastmatype: validate_mat(MOVING_AVERAGE_TYPES[fastmatype.to_sym]),
        slowmatype: validate_mat(MOVING_AVERAGE_TYPES[slowmatype.to_sym]),
        signalmatype: validate_mat(MOVING_AVERAGE_TYPES[signalmatype.to_sym])
      })
    end

    def stoch(
      fastkperiod: 5,
      slowkperiod: 3,
      slowdperiod: 3,
      slowkmatype: 'sma',
      slowdmatype: 'sma'
    )
      Client.get(params: {
        function: __callee__.upcase,
        symbol: @symbol,
        interval: validate_indicator_interval(@interval),
        fastkperiod: validate_integer(label: 'fastkperiod', value: fastkperiod),
        slowkperiod: validate_integer(label: 'slowkperiod', value: slowkperiod),
        slowdperiod: validate_integer(label: 'slowdperiod', value: slowdperiod),
        slowkmatype: validate_mat(MOVING_AVERAGE_TYPES[slowkmatype.to_sym]),
        slowdmatype: validate_mat(MOVING_AVERAGE_TYPES[slowdmatype.to_sym])
      })
    end

    def stochf(
      fastkperiod: 5,
      fastdperiod: 3,
      fastdmatype: 'sma'
    )
      Client.get(params: {
        function: __callee__.upcase,
        symbol: @symbol,
        interval: validate_indicator_interval(@interval),
        fastkperiod: validate_integer(label: 'fastkperiod', value: fastkperiod),
        fastdperiod: validate_integer(label: 'fastdperiod', value: fastdperiod),
        fastdmatype: validate_mat(MOVING_AVERAGE_TYPES[fastdmatype.to_sym])
      })
    end

    def stochrsi(
      time_period:,
      series_type:,
      fastkperiod: 5,
      fastdperiod: 3,
      fastdmatype: 'sma'
    )
      Client.get(params: {
        function: __callee__.upcase,
        symbol: @symbol,
        interval: validate_indicator_interval(@interval),
        time_period: validate_integer(label: 'time period', value: time_period),
        series_type: validate_series_type(series_type),
        fastkperiod: validate_integer(label: 'fastkperiod', value: fastkperiod),
        fastdperiod: validate_integer(label: 'fastdperiod', value: fastdperiod),
        fastdmatype: validate_mat(MOVING_AVERAGE_TYPES[fastdmatype.to_sym])
      })
    end

    def willr(time_period:)
      Client.get(params: {
        function: __callee__.upcase,
        symbol: @symbol,
        interval: validate_indicator_interval(@interval),
        time_period: validate_integer(label: 'time period', value: time_period)
      })
    end
    alias :adx      :willr
    alias :adxr     :willr
    alias :aroon    :willr
    alias :aroonosc :willr
    alias :mfi      :willr
    alias :dx       :willr
    alias :minus_di :willr
    alias :plus_di  :willr
    alias :minus_dm :willr
    alias :plus_dm  :willr
    alias :midprice :willr
    alias :atr      :willr
    alias :natr     :willr

    def vwap
      Client.get(params: {
        function: __callee__.upcase,
        symbol: @symbol,
        interval: [:bop,:trange,:ad,:obv].include?(__callee__) ? validate_indicator_interval(@interval) : validate_interval(@interval)
      })
    end
    alias :bop     :vwap
    alias :trange  :vwap
    alias :ad      :vwap
    alias :obv     :vwap

    def adosc(fastperiod: 3, slowperiod: 10)
      Client.get(params: {
        function: __callee__.upcase,
        symbol: @symbol,
        interval: validate_indicator_interval(@interval),
        fastperiod: validate_integer(label: 'fastperiod', value: fastperiod),
        slowperiod: validate_integer(label: 'slowperiod', value: slowperiod)
      })
    end

    def ht_trendline(series_type:)
      Client.get(params: {
        function: __callee__.upcase,
        symbol: @symbol,
        interval: validate_indicator_interval(@interval),
        series_type: validate_series_type(series_type)
      })
    end
    alias :ht_sine      :ht_trendline
    alias :ht_trendmode :ht_trendline
    alias :ht_dcperiod  :ht_trendline
    alias :ht_dcphase   :ht_trendline
    alias :ht_phasor    :ht_trendline

    def apo(series_type:, fastperiod: 12, slowperiod: 26, matype: 'sma')
      Client.get(params: {
        function: __callee__.upcase,
        symbol: @symbol,
        interval: validate_indicator_interval(@interval),
        series_type: validate_series_type(series_type),
        fastperiod: validate_integer(label: 'fastperiod', value: fastperiod),
        slowperiod: validate_integer(label: 'slowperiod', value: slowperiod),
        matype: validate_mat(MOVING_AVERAGE_TYPES[matype.to_sym])
      })
    end
    alias :ppo :apo

    def bbands(time_period:, series_type:, nbdevup: 2, nbdevdn: 2, matype: 'sma')
      Client.get(params: {
        function: __callee__.upcase,
        symbol: @symbol,
        interval: validate_indicator_interval(@interval),
        time_period: validate_integer(label: 'time period', value: time_period),
        series_type: validate_series_type(series_type),
        nbdevup: validate_integer(label: 'nbdevup', value: nbdevup),
        nbdevdn: validate_integer(label: 'nbdevdn', value: nbdevdn),
        matype: validate_mat(MOVING_AVERAGE_TYPES[matype.to_sym])
      })
    end

    def sar(acceleration: 0.01, maximum: 0.20)
      Client.get(params: {
        function: __callee__.upcase,
        symbol: @symbol,
        interval: validate_indicator_interval(@interval),
        acceleration: validate_integer(label: 'acceleration', value: acceleration),
        maximum: validate_integer(label: 'maximum', value: maximum)
      })
    end

    def ultosc(timeperiod1: 7, timeperiod2: 14, timeperiod3: 28)
      Client.get(params: {
        function: __callee__.upcase,
        symbol: @symbol,
        interval: validate_indicator_interval(@interval),
        timeperiod1: validate_integer(label: 'timeperiod1', value: timeperiod1),
        timeperiod2: validate_integer(label: 'timeperiod2', value: timeperiod2),
        timeperiod3: validate_integer(label: 'timeperiod3', value: timeperiod3)
      })
    end

  end
end