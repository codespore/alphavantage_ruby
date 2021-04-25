module Alphavantage
  module Validations
    VALID_SLICES = (1..2).map do |year|
      (1..12).map do |month|
        "year#{year}month#{month}"
      end
    end.flatten

    VALID_INTERVALS = %w{ 1min 5min 15min 30min 60min }
    VALID_OUTPUTSIZES = %{ compact full }

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