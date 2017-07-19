module ArticleParsing
  module Consts
    KNOWN_AUTHOR_METATAGS = [
      {attribute: 'property', value: 'tout:article:author', content: 'content'},
      {attribute: 'name', value: 'author', content: 'content'},
      {attribute: 'name', value: 'DC.creator', content: 'content'},
      {attribute: 'name', value: 'parsely-author', content: 'content'},
      {attribute: 'name', value: 'twitter:creator', content: 'content'},
    ]
    KNOWN_DATE_METATAGS = [
      {attribute: 'property', value: 'tout:article:pubdate', content: 'content'},
      {attribute: 'property', value: 'rnews:datePublished', content: 'content'},
      {attribute: 'property', value: 'article:published_time', content: 'content'},
      {attribute: 'name', value: 'OriginalPublicationDate', content: 'content'},
      {attribute: 'itemprop', value: 'datePublished', content: 'datetime'},
      {attribute: 'property', value: 'og:published_time', content: 'content'},
      {attribute: 'name', value: 'article_date_original', content: 'content'},
      {attribute: 'name', value: 'publication_date', content: 'content'},
      {attribute: 'name', value: 'sailthru.date', content: 'content'},
      {attribute: 'name', value: 'PublishDate', content: 'content'},
      {attribute: 'property', value: 'publish_time', content: 'content'},
      {attribute: 'name', value: 'publishdate', content: 'content'},
      {attribute: 'property', value: 'bt:pubDate', content: 'content'},
      {attribute: 'name', value: 'speare-timestamp', content: 'content'},
      {attribute: 'name', value: 'parsely-pub-date', content: 'content'},
      {attribute: 'itemprop', value: 'dateCreated', content: 'content'},
    ]

    REGEX_STRINGS = {
      'weekday_string': '(?:sun|mon|tue|wed|thu|fri|sat|sunday|monday|tuesday|thursday|friday|saturday|thurs|tues)',
      'month_string': '(?:jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec|january|february|march|april|may|june|july|august|september|october|november|december)',
      'year': '(?:197[0-9]|198[0-9]|199[0-9]|200[0-9]|201[0-9]|202[0-9]|203[0-9])',
      'month': '(?:10|11|12|(?:0|)[1-9])',
      'day': '(?:1[0-9]|2[0-9]|30|31|[0]{0,1}[1-9])',
      'hour': '(?:(?:0|)[0-9]|1[0-9]|2[0-3])',
      'minute': '(?:0[0-9]|[1-5][0-9])',
      'second': '(?:0[0-9]|[1-5][0-9])',
      'offset_minute': '(?:00|30|45)',
      'offset_operator': '[+-]',
      'opt_slash': '\/?',
      'opt_slashes': '(?:\/|)+',
      'uri_base': '(?:http\:\/\/|https\:\/\/|)(?:[a-z0-9A-Z\-]+\.)+[A-Z0-9a-z\-]+\/?',
    }
    KNOWN_EXTERNAL_ARTICLE_ID_METATAGS = [
      {attribute: 'property', value: 'vf:unique_id', content: 'content'},
      {attribute: 'property', value: 'tout:article:id', content: 'content'},
      {attribute: 'name', value: 'article.id', content: 'content'},
    ]
  end
end
