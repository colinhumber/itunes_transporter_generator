module Itunes
	module Transporter
		class Locale
			attr_accessor :language
			attr_accessor :title
	
			def initialize(language, title)
				@language = language
				@title = title
			end
		end
	end
end