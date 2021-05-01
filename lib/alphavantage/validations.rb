module Alphavantage
  module Validations
    VALID_SLICES = (1..2).map do |year|
      (1..12).map do |month|
        "year#{year}month#{month}"
      end
    end.flatten

    VALID_INTERVALS = %w{ 1min 5min 15min 30min 60min }
    VALID_INDICATOR_INTERVALS = VALID_INTERVALS + %w{ daily weekly monthly }
    VALID_OUTPUTSIZES = %w{ compact full }
    VALID_SERIES_TYPE = %w{ close open high low }

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

    def validate_indicator_interval(interval)
      raise Alphavantage::Error, "Invalid interval given." unless VALID_INDICATOR_INTERVALS.include?(interval)
      interval
    end

    def validate_series_type(series_type)
      raise Alphavantage::Error, "Invalid series type given." unless VALID_SERIES_TYPE.include?(series_type)
      series_type
    end

    def validate_time_period(time_period)
      raise Alphavantage::Error, "Invalid time period given. Must be integer." unless is_integer?(time_period)
      time_period
    end

    def validate_integer(label:,value:)
      raise Alphavantage::Error, "Invalid #{label} given. Must be integer." unless is_integer?(value)
      value
    end

    def validate_mat(moving_average_type)
      raise Alphavantage::Error, "Invalid moving average type given." if !(0..8).include?(moving_average_type)
      moving_average_type
    end

    def is_integer?(str)
      Integer(str) rescue false
    end
  end
end