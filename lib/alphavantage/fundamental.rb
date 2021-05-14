module Alphavantage
  class Fundamental
    FUNCTIONS = {
      overview: 'OVERVIEW',
      earnings: 'EARNINGS',
      income_statement: 'INCOME_STATEMENT',
      balance_sheet: 'BALANCE_SHEET',
      cash_flow: 'CASH_FLOW'
    }

    def initialize(symbol:)
      @symbol = symbol
    end

    def overview
      response(FUNCTIONS[__method__])
    end

    def earnings
      response(FUNCTIONS[__method__]).annual_earnings
    end

    def income_statement
      response(FUNCTIONS[__method__]).annual_reports
    end

    def balance_sheet
      response(FUNCTIONS[__method__]).annual_reports
    end

    def cash_flow
      response(FUNCTIONS[__method__]).annual_reports
    end

    private

    def response(function)
      Client.get(params: { function: function, symbol: @symbol })
    end
  end
end