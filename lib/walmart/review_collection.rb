require "nokogiri"
require "walmart/review"

module Walmart
  class ReviewCollection < Array
    def filter(value)
      select { |item| item.message && item.message.include?(value) }
    end

    def self.from_product_page(body)
      document = Nokogiri::HTML(body)
      document.css(".js-review-list .js-customer-review .customer-review-body").inject(new) do |items, node|
        items << Review.new.from_html_node(node)
        items
      end
    end
  end
end
