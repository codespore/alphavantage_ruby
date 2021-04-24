module AlphavantageRuby
  class TimeSeries

    FUNCTIONS = { 
      search: 'SYMBOL_SEARCH',
      quote: 'GLOBAL_QUOTES',
      monthly: 'TIME_SERIES_MONTHLY',
      monthly_adjusted: 'TIME_SERIES_MONTHLY_ADJUSTED',
      weekly: 'TIME_SERIES_WEEKLY',
      weekly_adjusted: 'TIME_SERIES_WEEKLY_ADJUSTED',
      daily: 'TIME_SERIES_DAILY',
      daily_adjusted: 'TIME_SERIES_DAILY_ADJUSTED'
    }

    def self.search(keywords:)
      Client.get(params: { function: self::FUNCTIONS[__method__], keywords: keywords }).best_matches
    end

    def initialize(symbol:)
      @symbol = symbol
    end

    def quote
      Client.get(params: { function: FUNCTIONS[__method__], symbol: @symbol }).global_quote
    end

    def monthly(adjusted: false)
      function = adjusted ? FUNCTIONS[:monthly_adjusted] : FUNCTIONS[__method__]
      Client.get(params: { function: function, symbol: @symbol })
    end

    def weekly(adjusted: false)
      function = adjusted ? FUNCTIONS[:weekly_adjusted] : FUNCTIONS[__method__]
      Client.get(params: { function: function, symbol: @symbol })
    end

    # `outputsize` can be either :compact (default) or :full
    def daily(adjusted: false, outputsize: :compact)
      function = adjusted ? FUNCTIONS[:daily_adjusted] : FUNCTIONS[__method__]
      Client.get(params: { function: function, symbol: @symbol, outputsize: outputsize })
    end

  end
end