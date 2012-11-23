require './in_app_purchase'

def get_in_app_purchases
	purchase1 = InAppPurchase.new('purchase1', 'First Purchase', CONSUMABLE, 'test.jpg')
	purchase1.add_product(Product.new(true, 1))
	purchase1.add_locale(ProductLocale.new('en', 'First Purchase', 'Some cools stuff.'))
	
	return [purchase1]
end