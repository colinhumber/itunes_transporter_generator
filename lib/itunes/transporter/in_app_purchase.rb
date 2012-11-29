module Itunes
  module Transporter
    class InAppPurchase < Struct.new(:product_id, :reference_name, :type, :duration, :free_trial_duration, :bonus_duration, :products, :locales, :review_screenshot_image, :review_notes, :should_remove)
			def to_s
				"Product ID: #{self.product_id} Reference Name: #{self.reference_name}"
			end
    end

    class Product < Struct.new(:cleared_for_sale, :intervals, :should_remove, :wholesale_price_tier)
    	def to_s
				"Cleared for sale: #{self.cleared_for_sale}, Tier: #{self.wholesale_pricing_tier}"
			end
    end

    class Interval < Struct.new(:start_date, :end_date, :wholesale_price_tier)
    end

    class PurchaseLocale < Struct.new(:name, :title, :description, :publication_name)
    end
  end
end