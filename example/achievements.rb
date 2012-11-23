require './achievement'

def get_achievements
	achievement1 = Achievement.new('achievement1', 'First Achievement', 10)
	achievement1.add_locale(AchievementLocale.new('en', 'First Achievement', 'Unlock achievement 1', 'Unlock achievement 1', 'test.jpg'))
	
	achievement2 = Achievement.new('achievement2', 'Second Achievement', 10)
	achievement2.add_locale(AchievementLocale.new('en', 'Second Achievement', 'Unlock achievement 2', 'Unlock achievement 2', 'test.jpg'))
	
	return [achievement1, achievement2]
end