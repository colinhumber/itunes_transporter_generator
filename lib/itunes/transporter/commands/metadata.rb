command :metadata do |c|
  	c.syntax = 'itmsp metadata [options]'
  	c.summary = ''
  	c.description = 'Generates iTunes Store Package metadata.xml from provided achievement, leaderboard, and/or in-app purchases provided'
  	c.example 'description', 'command example'
  	c.option '-a', 'Achievement ruby file (eg. achievements.rb)'
  	c.option '-l', 'Leaderboard ruby file (eg. leaderboards.rb)'
  	c.option '-p', 'In-App Purchases ruby file (eg. purchases.rb)'
  
  	c.action do |args, options|
		options.provider = ask 'Provider: '
		options.team_id = ask 'Team ID: '
		options.vendor_id = ask 'Vendor ID: '
		options.id_prefix = ask 'ID Prefix (eg. com.companyname.productname): '
			
		generator = Itunes::Transporter::Generator.new(options)
    	# Do something or c.when_called Itunes::Commands::Generate
  	end
end