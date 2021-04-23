module AlphavantageRuby
  class TimeSeries

    FUNCTIONS = { 
      search: 'SYMBOL_SEARCH' 
    }

    def self.search(keywords:)
      Client.get(params: { function: self::FUNCTIONS[__method__], keywords: keywords }).best_matches
    end

  end
end