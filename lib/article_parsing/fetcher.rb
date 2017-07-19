module ArticleParsing
  module Fetcher

    def self.fetch(url, options={})
      options = default_options(url).merge(options)
      HTTParty.get(url, options)
    rescue Errno::ECONNRESET #/Connection reset by peer - SSL_connect/
      # Try SSLv3 connection for a misconfigured Apache server
      # https://mattbrictson.com/tls-error-with-ruby-client-and-tomcat-server
      HTTParty.get(url, options.merge(use_ssl: true, ssl_version: :SSLv3))
    end

    def self.default_options(url)
      {
        headers: {
          'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36',
          'Referer' => "https://www.google.com/#q=#{url}"
        },
        maintain_method_across_redirects: true,
      }
    end

  end
end
