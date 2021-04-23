require 'faraday'
require 'hashie'

module AlphavantageRuby
  class Client

    class << self
      def get(params:)
        default_params = { apikey: AlphavantageRuby.configuration.api_key, datatype: 'json' }
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
            Hash[value.map { |k, v| [underscore_key(sanitize_key(k)), convert_hash_keys(v)] }]
          else
            value
         end
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
        key.to_s.scan(/\w*/).reject(&:empty?).last
      end
    end

  end
end