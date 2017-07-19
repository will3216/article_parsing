module ArticleParsing
  class OpenGraph
    attr_reader :title, :type, :image, :url, :video

    #TODO: Implement the whole spec - http://ogp.me/
    #TODO: Should be passed a document object
    def initialize(web_page)
      @title = web_page.detect_meta_tag('property', 'og:title', 'content')
      @type = web_page.detect_meta_tag('property', 'og:type', 'content')
      @image = parse_media(:image, web_page)
      @url = web_page.detect_meta_tag('property', 'og:url', 'content')
      @video = parse_media(:video, web_page)
    end

    def parse_media(media_type, web_page)
      OpenStruct.new({
        url: web_page.detect_meta_tag('property', "og:#{media_type}", 'content'),
        secure_url: web_page.detect_meta_tag('property', "og:#{media_type}:secure_url", 'content'),
        type: web_page.detect_meta_tag('property', "og:#{media_type}:type", 'content'),
        width: web_page.detect_meta_tag('property', "og:#{media_type}:width", 'content'),
        height: web_page.detect_meta_tag('property', "og:#{media_type}:height", 'content'),
      })
    end

  end
end
