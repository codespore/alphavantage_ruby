module Alphavantage
  class TimeSeries

    FUNCTIONS = { 
      search: 'SYMBOL_SEARCH',
      quote: 'GLOBAL_QUOTES',
      monthly: 'TIME_SERIES_MONTHLY',
      monthly_adjusted: 'TIME_SERIES_MONTHLY_ADJUSTED',
      weekly: 'TIME_SERIES_WEEKLY',
      weekly_adjusted: 'TIME_SERIES_WEEKLY_ADJUSTED',
      daily: 'TIME_SERIES_DAILY',
      daily_adjusted: 'TIME_SERIES_DAILY_ADJUSTED',
      intraday: 'TIME_SERIES_INTRADAY',
      intraday_extended_history: 'TIME_SERIES_INTRADAY_EXTENDED'
    }

    VALID_SLICES = (1..2).map do |year|
      (1..12).map do |month|
        "year#{year}month#{month}"
      end
    end.flatten

    VALID_INTERVALS = %w{ 1min 5min 15min 30min 60min }
    VALID_OUTPUTSIZES = %{ compact full }

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

    def daily(adjusted: false, outputsize: 'compact')
      function = adjusted ? FUNCTIONS[:daily_adjusted] : FUNCTIONS[__method__]
      Client.get(params: { function: function, symbol: @symbol, outputsize: validate_outputsize(outputsize) })
    end

    def intraday(adjusted: true, outputsize: 'compact', interval: '5min', extended_history: false, slice: 'year1month1')
      if extended_history
        raise Alphavantage::Error, "Extended history returns a CSV which will be supported at a later time."
        # params = { 
        #   function: FUNCTIONS[:intraday_extended_history], 
        #   symbol: @symbol, 
        #   slice: validate_slice(slice), 
        #   interval: validate_interval(interval), 
        #   adjusted: adjusted 
        # }
      else
        params = { 
          function: FUNCTIONS[__method__], 
          symbol: @symbol, 
          outputsize: validate_outputsize(outputsize), 
          interval: validate_interval(interval), 
          adjusted: adjusted 
        }
      end
      Client.get(params: params)
    end

    private

    def validate_slice(slice)
      raise Alphavantage::Error, "Invalid slice given." unless VALID_SLICES.include?(slice)
      slice
    end

    def validate_interval(interval)
      raise Alphavantage::Error, "Invalid interval given." unless VALID_INTERVALS.include?(interval)
      interval
    end

    def validate_outputsize(outputsize)
      raise Alphavantage::Error, "Invalid outputsize given." unless VALID_OUTPUTSIZES.include?(outputsize)
      outputsize
    end

  end
end