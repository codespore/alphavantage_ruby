module Alphavantage
  class NormalizeKey
    def initialize(key:)
      @key = key
    end

    def call
      return @key if is_date?(@key)
      underscore_key(sanitize_key(@key))
    end

    private

    def underscore_key(key)
      key.to_s.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase.to_sym
    end

    def sanitize_key(key)
      key.tr('.()','').gsub(/^\d+.?\s/, "").tr(' ','_')
    end

    def is_date?(key)
      !/(\d{4}-\d{2}-\d{2})/.match(key.to_s).nil?
    end
  end
end