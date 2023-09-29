module Alphavantage
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end

  class Configuration
    # Allows @api_key to be a Proc, for example
    # as an API Key Manager or Rate Limiter.
    #
    def api_key
      if @api_key.is_a?(Proc)
        @api_key.call
      else
        @api_key
      end
    end


    # Typically an_object is a String but
    # it can also be a Proc
    #
    def api_key=(an_object)
      @api_key = an_object
    end
  end
end
