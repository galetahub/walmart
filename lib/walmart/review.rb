module Walmart
  class Review
    attr_reader :customer_name, :rating, :message

    def from_html_node(node)
      @customer_name = node.css('.customer-review-title').text
      @rating = node.css('span.visuallyhidden').text.to_f
      @message = node.css('p.js-customer-review-text').text

      self
    end
  end
end
