require 'itunes/transporter/generator'

command :package do |c|
  	c.syntax = 'itmsp package [options]'
  	c.summary = ''
  	c.description = 'Generates iTunes Store Package metadata.xml from provided achievement, leaderboard, and/or in-app purchases provided'
  	c.example 'description', 'command example'
  	c.option '-i FILENAME', '--input FILENAME', String, 'YAML file containing app/team values, achievement, leaderboard, and/or in-app purchase descriptions'
  
  	c.action do |args, options|		
		Itunes::Transporter::Generator.new(options).generate_metadata
  	end
end
