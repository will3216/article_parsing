require 'active_support/core_ext/object/try'
require 'article_parsing/consts'

module ArticleParsing
  module DateParser

    REGEX_STRINGS = {
      weekday_string: '(?:sun|mon|tue|wed|thu|fri|sat|sunday|monday|tuesday|thursday|friday|saturday|thurs|tues)',
      month_string: '(?:jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec|january|february|march|april|may|june|july|august|september|october|november|december)',
      year: '(?:197[0-9]|198[0-9]|199[0-9]|200[0-9]|201[0-9]|202[0-9]|203[0-9])',
      month: '(?:10|11|12|(?:0|)[1-9])',
      day: '(?:1[0-9]|2[0-9]|30|31|[0]{0,1}[1-9])',
      hour: '(?:(?:0|)[0-9]|1[0-9]|2[0-3])',
      minute: '(?:0[0-9]|[1-5][0-9])',
      second: '(?:0[0-9]|[1-5][0-9])',
      offset_minute: '(?:00|30|45)',
      offset_operator: '[+-]',
      opt_slash: '\/?',
      opt_slashes: '(?:\/|)+',
      uri_base: '(?:http\:\/\/|https\:\/\/|)(?:[a-z0-9A-Z\-]+\.)+[A-Z0-9a-z\-]+\/?',
      path: '[a-z][\.\-a-z]*',
    }

    def self.month_conversion(month_string)
      case month_string.downcase
      when /jan|january/i then '01'
      when /feb|february/i then '02'
      when /mar|march/ then '03'
      when /apr|april/ then '04'
      when /may/ then '05'
      when /jun|june/ then '06'
      when /jul|july/ then '07'
      when /aug|august/ then '08'
      when /sep|september/ then '09'
      when /oct|october/ then '10'
      when /nov|november/ then '11'
      when /dec|december/ then '12'
      end
    end

    def self.from_document(document)
      Consts::KNOWN_DATE_METATAGS.map do |known_attrs|
        document.detect_meta_tag(known_attrs[:attribute], known_attrs[:value], known_attrs[:content])
      end.compact.reject(&:blank?).first
    end

    def self.from_url(url)
      uri = ::URI.parse(url)
      date = DateTime.parse(date_from_query(uri.query)) rescue nil
      return date if date
      DateTime.parse(date_from_path(uri.path)) rescue nil
    end

    def self.date_from_path(path)
      path.match(date_matcher).try(:[], 1)
    end

    def self.date_from_query(query)
      query.match(date_matcher).try(:[], 1)
    end

    def self.date_from_query_regex
      /(?:apps\/pbcs\.dll\/article\\?AID\=(?:\/|\%2f)|article\/(?:zz\/|))(#{date_matcher})(?:\/|\%2f)\.*(?:\/|\%2f)[0-9]{7,8}[0-9]{0,1}/
    end

    def self.month_matcher
      "(?:#{REGEX_STRINGS[:month_string]}|#{REGEX_STRINGS[:month]})"
    end

    def self.date_matcher
      Regexp.new([
        '\D(',
        REGEX_STRINGS[:year],
        REGEX_STRINGS[:opt_slash],
        month_matcher,
        REGEX_STRINGS[:opt_slash],
        '(?:',
        REGEX_STRINGS[:day],
        '|))(?:\D|$)'
      ]*'')
    end

    # def date_regex(path)
    #   var monthMatcher = ;
    #   var path = ;
    #   var dateMatcher =
    #   var dateFromUrlRegexes = [
    #     ['^(?:https?\:\/\/|https\:\/\/|)(?:www\.|)[^\/]*(?:\/|\/+)(?:apps\/pbcs\.dll\/article\\?AID\=(?:\/|\%2f)|article\/(?:zz\/|))(' +dateMatcher+ ')(?:\/|\%2f)\.*(?:\/|\%2f)[0-9]{7,8}[0-9]{0,1}', 'i'],
    #     ['^(?:http\:\/\/|https\:\/\/|)(?:www\.|)[^\/]*(?:\/|\/+)(?:' +path+ '\/|)*(' +REGEX_STRINGS.year+ '\/' +monthMatcher+ '(?:\/' +REGEX_STRINGS.day+ '|))\/.*', 'i'],
    #     ['^(?:http\:\/\/|https\:\/\/|)(?:www\.|)[^\/]*(?:\/|\/+)(?:' +path+ '\/|)*' +path+ '\-(' +dateMatcher+ ')(?:\-[0-9]{10}\-[0-9]{2}|)(?:\/[0-9]|)$', 'i'],
    #   ];
  end
end
