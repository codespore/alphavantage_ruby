require 'faraday'
require 'hashie'
module Alphavantage
  class Client

    class << self
      def get(params:)
        default_params = { apikey: Alphavantage.configuration.api_key }
        response = Faraday.get('https://www.alphavantage.co/query') do |req|
          req.params = default_params.merge(params)
          req.headers['Content-Type'] = 'application/json'
        end
        Hashie::Mash.new(convert_hash_keys(JSON.parse(response.body)))
      end

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
    end

  end
end