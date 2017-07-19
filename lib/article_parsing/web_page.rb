require 'article_parsing/consts'
require 'article_parsing/uri'
require 'article_parsing/fetcher'
require 'article_parsing/open_graph'
require 'article_parsing/date_parser'
require 'active_support/core_ext/object/try'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/module/delegation'
require 'nokogiri'
require 'httparty'

module ArticleParsing
  class WebPage
    attr_reader :uri, :options, :parsed, :open_graph

    def og_url
      open_graph.url
    end

    def title
      open_graph.title
    end

    def canonical_url
      [
        og_url,
        rel_canonical,
        window_location,
      ].compact.first
    end

    def window_location
      url
    end

    def url
      uri.to_s
    end

    def internal_site_links
      domain = uri.domain
      return [] unless domain
      uris_by_domain(uri.domain).map(&:to_s)
    end

    def initialize(url, options={})
      #TODO: The custom URI did not pan out, replace it
      @uri = ArticleParsing::URI.new(url)
      @options = options
      @parsed = Nokogiri::HTML::Document.parse(Fetcher.fetch(uri.to_s))
      @open_graph = OpenGraph.new(self)
    end

    def all_urls
      @all_urls ||= scrape_urls
    end

    def all_uris
      #QUESTION: Should I be checking any other tag types? Should this be configurable?
      all_urls.map do |url|
        begin
          ArticleParsing::URI.new(url)
        rescue ::URI::InvalidURIError
          nil
        end
      end.compact
    end

    def uris_by_domain(target_domain)
      # QUESTION: Maybe build a hash?
      all_uris.select do |filter_uri|
        filter_uri.domain == target_domain
      end
    end

    def scrape_urls
      parsed.css('a').map do |link|
        if (href = link.attr('href')) && href.match(/^https?:/)
          href
        end
      end.compact.uniq.sort
    end

    def detect_meta_tag(match_attr_name, match_attr_value, target_attr)
      parsed.css("meta[#{match_attr_name}='#{match_attr_value}']").first.try(:attr, target_attr)
    end

    def publication_date
      @publication_date ||= DateParser.from_document(self) || DateParser.from_url(uri.to_s)
    end

    def rel_canonical
      rel = parsed.css('link[rel="canonical"]').first.try(:attr, 'href')
      return nil unless rel
      rel[0] == '/' ? "#{uri.scheme}://#{uri.host}#{rel}" : rel
    end

    def external_article_id
      @external_article_id ||= [
        external_article_id_from_known_tags,
        external_article_id_from_url,
      ].compact.first
    end

    def vf_unique_id
      @vf_unique_id ||= parsed.css('meta[property="vf:unique_id"]').first.try(:attr, 'content')
    end

    def tout_article_id
      @tout_article_id ||= parsed.css('meta[property="tout:article:id"]').first.try(:attr, 'content')
    end

    def external_article_id_from_known_tags
      Consts::KNOWN_EXTERNAL_ARTICLE_ID_METATAGS.map do |known_attrs|
        detect_meta_tag(known_attrs[:attribute], known_attrs[:value], known_attrs[:content])
      end.compact.reject(&:blank?).first
    end

    def external_article_id_from_url
      [
        # http://www.denverpost.com/avalanche/ci_26914692/avs-set-make-final-regular-season-visit-nassau
        uri.path.split('/').detect {|path_segment| path_segment.match(/ci_\w{7}\w*/)},
        # http://www.hutchnews.com/news/national_world_news/kurdish-fighters-help-islamic-state-group-militants/article_38ddd3c0-dd02-56f3-a8a6-98a01cd74dba.html
        uri.path.split('/').detect {|path_segment| path_segment.match(/article_[A-Za-z0-9\-\_]{36}/)},
        #TODO: More of these with hole testing! Rawr
      ].compact.first
    end

    def attributes
      %w{
        title
        author
        publication_date
        canonical_url
        external_article_id
        og_url
        rel_canonical
        window_location
      }.map(&:to_sym).inject({}) do |h, k|
        h.merge(k => send(k))
      end
    end

    def author
      # TODO: Consts should be replaced with something configurable
      @author ||= Consts::KNOWN_AUTHOR_METATAGS.map do |known_attrs|
        detect_meta_tag(known_attrs[:attribute], known_attrs[:value], known_attrs[:content])
      end.compact.reject(&:blank?).first
    end
  end
end
