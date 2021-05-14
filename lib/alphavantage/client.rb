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
      Hashie::Mash.new(convert_hash_keys(JSON.parse(response.body)))
    end

    def csv
      CSV.parse response.body
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
      Faraday.get('https://www.alphavantage.co/query') do |req|
        req.params = default_params.merge(params)
      end
    end

    def default_params
      {
        apikey: Alphavantage.configuration.api_key || SecureRandom.alphanumeric(16).upcase
      }
    end
  end
end