require 'itunes/transporter/generator'

command :generate do |c|
  	c.syntax = 'itmsp metadata [options]'
  	c.summary = ''
  	c.description = 'Generates iTunes Store Package metadata.xml from provided achievement, leaderboard, and/or in-app purchases provided'
  	c.example 'description', 'command example'
  	c.option '-a', 'Achievement ruby file (eg. achievements.rb)'
  	c.option '-l', 'Leaderboard ruby file (eg. leaderboards.rb)'
  	c.option '-p', 'In-App Purchases ruby file (eg. purchases.rb)'
  
  	c.action do |args, options|
		Itunes::Transporter::Generator.new(options).generate_itmsp
  	end
end