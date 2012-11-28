module Itunes
  module Transporter
    class Achievement < Struct.new(:id, :name, :points, :hidden, :reusable, :should_remove, :locales) 
    end

    class AchievementLocale < Struct.new(:name, :title, :before_earned_description, :after_earned_description, :after_earned_image, :should_remove)
    end
  end
end