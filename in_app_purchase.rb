require './locale'

CONSUMABLE = 'consumable'
NON_CONSUMABLE = 'non-consumable'
SUBSCRIPTION = 'subscription'
FREE_SUBSCRIPTION = 'free-subscription'

class InAppPurchase
	attr_accessor :product_id
	attr_accessor :reference_name
	attr_accessor :type
	attr_accessor :products
	attr_accessor :locales
	attr_accessor :review_screenshot_image_name
	attr_accessor :review_notes
	attr_accessor :should_remove
	
	def initialize(product_id, reference_name, type, review_screenshot_image_name)
		@product_id = product_id
		@reference_name = reference_name
		@type = type
		@review_screenshot_image_name = review_screenshot_image_name
		@products = Array.new
		@locales = Array.new
		@should_remove = false
		@review_notes = ''
	end
	
	def add_product(product)
		@products << product		
	end
	
	def add_locale(locale)
		@locales << locale
	end
end

class Product
	attr_accessor :cleared_for_sale
	attr_accessor :intervals
	attr_accessor :should_remove
	attr_accessor :wholesale_price_tier
	
	def initialize(cleared_for_sale, wholesale_price_tier)
		@cleared_for_sale = cleared_for_sale
		@wholesale_price_tier = wholesale_price_tier
		@should_remove = false
		@intervals = Array.new
	end
	
	def add_interval(interval)
		@intervals << interval
	end
end

class Interval
	attr_accessor :start_date
	attr_accessor :end_date
	attr_accessor :wholesale_price_tier

	def initialize(wholesale_price_tier)
		@wholesale_price_tier = wholesale_price_tier
	end
end

class ProductLocale < Locale
	attr_accessor :description
	attr_accessor :publication_name
	
	def initialize(language, title, description)
		@description = description
		super(language, title)
	end
end