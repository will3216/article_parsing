require 'active_support/core_ext/module/delegation'

module ArticleParsing
  class URI
    attr_reader :uri

    delegate :to_s, :host, :path, :port, :scheme, :opaque, :query, :registry, to: :uri

    def initialize(url)
      @uri = if url.is_a?(URI)
        url
      else
        ::URI.parse(url)
      end
    # rescue URI::InvalidURIError
    #   nil
    end

    def valid?
      uri.present?
    end

    def domain
      uri.host.try(:[], -2..-1).try(:*, '.') if valid?
    end
  end
end
