require './leaderboard'

def get_leaderboards
	default = Leaderboard.new('leaderboard', 'Top Scores')
	locale = LeaderboardLocale.new('en', 'Top Scores', INTEGER_COMMA_SEPARATOR, 'test.jpg')
	locale.formatter_suffix = ' Points'
	locale.formatter_suffix_singular = ' Points'
	
	default.add_locale(locale)
	
	return [default]
end