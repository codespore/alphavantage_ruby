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
            Hash[value.map { |k, v| [filter_key(k), convert_hash_keys(v)] }]
          else
            value
         end
      end

      def filter_key(key)
        return key if is_date?(key)
        underscore_key(sanitize_key(key))
      end

      # Because I don't like camels
      def underscore_key(key)
        key.to_s.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase.to_sym
      end

      # Because for some reason, calling search returns keys like "1. symbol"
      def sanitize_key(key)
        key.to_s.gsub(/\W+/,"").gsub(/^\d+/, "")
      end

      def is_date?(key)
        !/(\d{4}-\d{2}-\d{2})/.match(key.to_s).nil?
      end
    end

  end
end