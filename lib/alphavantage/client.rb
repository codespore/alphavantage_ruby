require 'securerandom'
require 'json'
require 'csv'

module Alphavantage
  class Client

    class << self
      def get(params:, datatype: :json)
        new(params).public_send(datatype)
      end
    end

    def initialize params
      @params = params
    end
    attr_reader :params

    def json
      Hashie::Mash.new(convert_hash_keys(JSON.parse(response.body))).tap do |response|
        raise Error, response.error_message if response.error_message
      end
    end

    def csv
      CSV.parse response.body
    rescue CSV::MalformedCSVError
      # if we can not parse it, we probably have JSON from API with an error
      json
      raise
    end

    private

    def convert_hash_keys(value)
      case value
        when Array
          value.map { |v| convert_hash_keys(v) }
        when Hash
          Hash[value.map { |k, v| [ NormalizeKey.new(key: k).call, convert_hash_keys(v) ] }]
        else
          value
        end
    end

    def response
      @response ||= Faraday.get('https://www.alphavantage.co/query') do |req|
        req.params = default_params.merge(params)
      end.tap do |response|
        next if response.status == 200

        raise Error, "Response status: #{response.status}, body: #{response.body}"
      end
    end

    def default_params
      {
        apikey: Alphavantage.configuration.api_key || SecureRandom.alphanumeric(16).upcase
      }
    end
  end
end