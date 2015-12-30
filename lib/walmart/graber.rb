require "httparty"
require 'walmart/review'

module Walmart
  class Graber
    URL = "http://www.walmart.com/reviews/api/product/{id}?limit=1000&page=1&sort=helpful&filters=&showProduct=false"

    class ParseError < StandardError
    end

    def initialize(product_id)
      @product_id = product_id.to_s
    end

    def reviews
      response = fetch
      parse_response(response)
    end

    protected

      def fetch
        response = HTTParty.get(URL.gsub('{id}', @product_id))

        case response.code
        when 200 then response
        else
          raise ParseError.new
        end
      end

      def parse_response(response)
        json = JSON.parse(response.body)
        Review.from_product_page(json['reviewsHtml'])
      end
  end
end
