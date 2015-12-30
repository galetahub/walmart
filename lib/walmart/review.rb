require "nokogiri"

module Walmart
  class Review
    attr_reader :customer_name, :rating, :message

    def from_html_node(node)
      @customer_name = node.css('.customer-review-title').text
      @rating = node.css('span.visuallyhidden').text.to_f
      @message = node.css('p.js-customer-review-text').text
      self
    end

    def self.from_product_page(body)
      document = Nokogiri::HTML(body)
      document.css(".js-review-list .js-customer-review .customer-review-body").inject([]) do |items, node|
        items << Review.new.from_html_node(node)
        items
      end
    end
  end
end
