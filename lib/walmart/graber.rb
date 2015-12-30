require "httparty"
require 'walmart/review_collection'

module Walmart
  class Graber
    PER_PAGE = 20
    URL = "http://www.walmart.com/reviews/api/product/{id}?limit=#{PER_PAGE}&page={page}&sort=helpful&filters=&showProduct=false".freeze

    class ParseError < StandardError
    end

    def initialize(product_id)
      @product_id = product_id.to_s
    end

    def reviews
      @reviews ||= fetch_all_pages
    end

    protected

      def fetch_all_pages
        _page = 1
        _reviews = ReviewCollection.new
        _items = []

        until _items.size == 0 && _page > 1 do
          _items = parse_response(fetch(_page))
          _reviews.concat(_items)
          _page += 1
        end

        _reviews
      end

      def fetch(page)
        _url = URL.gsub('{id}', @product_id).gsub('{page}', page.to_s)
        response = HTTParty.get(_url)

        case response.code
        when 200 then response
        else
          raise ParseError.new
        end
      end

      def parse_response(response)
        json = JSON.parse(response.body)
        ReviewCollection.from_product_page(json['reviewsHtml'])
      end
  end
end
