# frozen_string_literal: true

require 'uri'

module Chatwoot
  class ConfiguredOrigin
    def self.from_env(name)
      value = ENV[name]
      return if value.blank?

      uri = URI.parse(value)
      unless uri.is_a?(URI::HTTPS) && uri.host.present? && uri.userinfo.nil? &&
             (uri.path.blank? || uri.path == '/') && uri.query.nil? && uri.fragment.nil? && uri.port.between?(1, 65_535)
        raise ArgumentError, "#{name} must be an HTTPS origin without a path, credentials, query, or fragment"
      end

      uri.path = ''
      uri
    rescue URI::InvalidURIError
      raise ArgumentError, "#{name} must be a valid HTTPS origin"
    end
  end
end
