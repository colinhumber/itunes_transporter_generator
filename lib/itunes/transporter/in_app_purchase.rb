module Itunes
	module Transporter
		
		CONSUMABLE = 'consumable'
		NON_CONSUMABLE = 'non-consumable'
		SUBSCRIPTION = 'subscription'
		FREE_SUBSCRIPTION = 'free-subscription'

		DURATION_7_DAYS = '7 Days'
		DURATION_1_MONTH = '1 Month'
		DURATION_2_MONTHS = '2 Months'
		DURATION_3_MONTHS = '3 Months'
		DURATION_6_MONTH = '6 Months'
		DURATION_1_YEAR = '1 Year'

		class InAppPurchase < Struct.new(:product_id, :reference_name, :type, :duration, :free_trial_duration, :bonus_duration, :products, :locales, :review_screenshot_image, :review_notes, :should_remove)
		end

		class Product < Struct.new(:cleared_for_sale, :intervals, :should_remove, :wholesale_price_tier)
		end

		class Interval < Struct.new(:start_date, :end_date, :wholesale_price_tier)
		end

		class PurchaseLocale < Struct.new(:name, :title, :description, :publication_name)
		end
	end
end