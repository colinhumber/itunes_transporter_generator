require './locale'
module Itunes
	module Transporter
		class Achievement	
			attr_accessor :id
			attr_accessor :name
			attr_accessor :points
			attr_accessor :hidden
			attr_accessor :reusable
			attr_accessor :locales
			attr_accessor :should_remove

			def initialize(id, name, points)
				@id = id
				@name = name
				@points = points
				@hidden = false
				@reusable = false
				@locales = Array.new
				@should_remove = false
			end
	
			def add_locale(locale)
				@locales << locale		
			end
		end

		class AchievementLocale < Locale
			attr_accessor :before_earned_description
			attr_accessor :after_earned_description
			attr_accessor :after_earned_image_name
			attr_accessor :should_remove
	
			def initialize(language, title, before_earned_description, after_earned_description, after_earned_image_name)
				@before_earned_description = before_earned_description
				@after_earned_description = after_earned_description
				@after_earned_image_name = after_earned_image_name
				@should_remove = false

				super(language, title)
			end
		end
	end
end