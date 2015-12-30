require "httparty"
require "nokogiri"

module Walmart
  class Searcher
    URL = "http://www.walmart.com/search/?query={id}&page=1&cat_id=0&ajax=true&ts=1451468470125"

    def initialize(query)
      @query = Rack::Utils.escape(query)
    end

    def product_id
      @product_id ||= find_product_id
    end

    protected

      def find_product_id
        response = fetch

        json = JSON.parse(response.body)
        Nokogiri.HTML(json['searchContent']).css("a.js-product-title").attr('href').text.split('/').last
      end

      def fetch
        response = HTTParty.get(URL.gsub('{id}', @query))

        case response.code
        when 200 then response
        else
          raise Graber::ParseError.new
        end
      end

  end
end
