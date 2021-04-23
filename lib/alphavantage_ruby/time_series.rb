module AlphavantageRuby
  class TimeSeries

    FUNCTIONS = { 
      search: 'SYMBOL_SEARCH',
      quote: 'GLOBAL_QUOTES'
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

  end
end