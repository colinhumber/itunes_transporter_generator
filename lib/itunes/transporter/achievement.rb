module Itunes
  module Transporter
    class Achievement < Struct.new(:id, :name, :points, :hidden, :reusable, :should_remove, :locales) 
		  def to_s
			  #{self.id} #{self.name}
		  end
    end

    class AchievementLocale < Struct.new(:name, :title, :before_earned_description, :after_earned_description, :after_earned_image, :should_remove)
		  def to_s
			  #{self.name} #{self.title}
		  end
    end
  end
end