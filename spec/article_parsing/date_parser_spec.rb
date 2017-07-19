require 'active_support/all'
require 'article_parsing/date_parser'
require 'spec_helper'

describe ArticleParsing::DateParser do


  describe '.from_url' do
    subject { described_class.from_url(url) }
    puts "path: #{described_class.date_matcher.inspect}"
    puts "query: #{described_class.date_from_query_regex.inspect}"
    context 'parseable url' do
      it 'should parse the date correctly' do
        fixture('urls_with_parseable_date.json').each do |parseable_url|
          parsed = described_class.from_url(parseable_url)
          puts "FAILED: \n\turl: '#{parseable_url}'" unless parsed
          expect(parsed).to be_a(DateTime)
          expect(parsed < DateTime.now).to eq true
          expect(parsed > 30.years.ago).to eq true
        end
      end
    end

    context 'unparseable url' do
      it 'should parse the date correctly' do
        fixture('urls_without_parseable_date.json').each do |unparseable_url|
          parsed = described_class.from_url(unparseable_url)
          puts "FAILED: \n\turl: '#{unparseable_url}'\n\treturned: #{parsed.to_s}" if parsed
          expect(parsed).to be_nil
        end
      end
    end
  end
end
