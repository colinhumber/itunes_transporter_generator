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
			# attr_accessor :product_id
			# 			attr_accessor :reference_name
			# 			attr_accessor :type
			# 			attr_accessor :products
			# 			attr_accessor :locales
			# 			attr_accessor :review_screenshot_image_name
			# 			attr_accessor :review_notes
			# 			attr_accessor :should_remove
			# 	
			# 			def initialize(product_id, reference_name, type, review_screenshot_image_name)
			# 				@product_id = product_id
			# 				@reference_name = reference_name
			# 				@type = type
			# 				@review_screenshot_image_name = review_screenshot_image_name
			# 				@products = Array.new
			# 				@locales = Array.new
			# 				@should_remove = false
			# 				@review_notes = ''
			# 			end
			# 	
			# 			def add_product(product)
			# 				@products << product		
			# 			end
			# 	
			# 			def add_locale(locale)
			# 				@locales << locale
			# 			end
		end

		class Product < Struct.new(:cleared_for_sale, :intervals, :should_remove, :wholesale_price_tier)
			# attr_accessor :cleared_for_sale
			# 			attr_accessor :intervals
			# 			attr_accessor :should_remove
			# 			attr_accessor :wholesale_price_tier
			# 	
			# 			def initialize(cleared_for_sale, wholesale_price_tier)
			# 				@cleared_for_sale = cleared_for_sale
			# 				@wholesale_price_tier = wholesale_price_tier
			# 				@should_remove = false
			# 				@intervals = Array.new
			# 			end
			# 	
			# 			def add_interval(interval)
			# 				@intervals << interval
			# 			end
		end

		class Interval < Struct.new(:start_date, :end_date, :wholesale_price_tier)
			# attr_accessor :start_date
			# attr_accessor :end_date
			# attr_accessor :wholesale_price_tier
			# 
			# def initialize(wholesale_price_tier)
			# 	@wholesale_price_tier = wholesale_price_tier
			# end
		end

		class PurchaseLocale < Struct.new(:name, :title, :description, :publication_name)
			# attr_accessor :description
			# attr_accessor :publication_name
			# 	
			# def initialize(language, title, description)
			# 	@description = description
			# 	super(language, title)
			# end
		end
	end
end