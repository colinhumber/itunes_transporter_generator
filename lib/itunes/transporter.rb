module Itunes
  module Transporter
    class Achievement < Struct.new(:id, :name, :points, :hidden, :reusable, :should_remove, :locales)
		  def to_s
			  "#{self.id} #{self.name}"
		  end
    end

    class AchievementLocale < Struct.new(:name, :title, :before_earned_description, :after_earned_description, :achievement_after_earned_image, :should_remove)
		  def to_s
			  "#{self.name} #{self.title}"
		  end
    end

    class Leaderboard < Struct.new(:default, :id, :name, :aggregate_parent_leaderboard, :sort_ascending, :score_range_min, :score_range_max, :locales)
      def to_s
        "#{self.name} #{self.title}"
      end
    end

    class LeaderboardLocale < Struct.new(:name, :title, :formatter_suffix, :formatter_suffix_singular, :formatter_type, :leaderboard_image, :should_remove)
      def to_s
        "#{self.name} #{self.title}"
      end
    end

    class InAppPurchase < Struct.new(:product_id, :reference_name, :type, :duration, :free_trial_duration, :bonus_duration, :products, :locales, :review_screenshot_image, :review_notes, :should_remove)
      def to_s
        "Product ID: #{self.product_id} Reference Name: #{self.reference_name}"
      end
    end

    class Family < Struct.new(:name, :review_screenshot_image, :review_notes, :locales, :purchases)
      def to_s
        "Name: #{self.name} Purchases: #{self.purchases}"
      end
    end

    class Product < Struct.new(:cleared_for_sale, :intervals, :should_remove, :wholesale_price_tier)
      def to_s
        "Cleared for sale: #{self.cleared_for_sale}, Tier: #{self.wholesale_price_tier}"
      end
    end

    class Interval < Struct.new(:start_date, :end_date, :wholesale_price_tier)
      def to_s
        "Start date: #{self.start_date} End Date: #{self.end_date} Tier: #{self.wholesale_price_tier}"
      end
    end

    class PurchaseLocale < Struct.new(:name, :title, :description, :publication_name)
      def to_s
        "Name: #{self.name} Title: #{self.title}"
      end
    end

    class Version < Struct.new(:name, :locales)
      def to_s
        self.name
      end
    end

    class VersionLocale < Struct.new(:name, :title, :description, :keywords, :version_whats_new, :software_url, :privacy_url, :support_url, :screenshots)
      def to_s
        "#{self.name} #{self.title}"
      end
    end

    module MetadataImage
      def normalized_source_filename
        File.basename(self.file_name).tr('/: ','_')
      end

      def friendly_filename(filename)
        filename.gsub(/[^\w\s_-]+/, '')
        .gsub(/(^|\b\s)\s+($|\s?\b)/, '\\1\\2')
        .gsub(/\s+/, '_')
      end
    end

    class VersionScreenshot < Struct.new(:display_target, :file_name, :position, :locale_name)
      include MetadataImage

      def to_s
        "#{self.locale_name} - (#{self.position}) #{self.display_target} - #{self.file_name}"
      end

      def normalized_filename
        "#{self.locale_name}_#{self.position}_#{self.display_target}_#{normalized_source_filename}"
      end
    end

    class AchievementImage < Struct.new(:id, :file_name)
      include MetadataImage

      def to_s
        "achievement #{self.id} - #{self.file_name}"
      end

      def normalized_filename
        "achievement_#{friendly_filename(id)}_#{normalized_source_filename}"
      end
    end

    class LeaderboardImage < Struct.new(:id, :file_name)
      include MetadataImage

      def to_s
        "leaderboard #{self.id} - #{self.file_name}"
      end

      def normalized_filename
        "leaderboard_#{friendly_filename(id)}_#{normalized_source_filename}"
      end
    end

    class IAPReviewImage < Struct.new(:id, :file_name)
      include MetadataImage

      def to_s
        "iap #{self.id} - #{self.file_name}"
      end

      def normalized_filename
        "iap_#{friendly_filename(id)}_#{normalized_source_filename}"
      end
    end

    class IAPFamilyReviewImage < Struct.new(:name, :file_name)
      include MetadataImage

      def to_s
        "iap #{self.name} - #{self.file_name}"
      end

      def normalized_filename
        "iap_#{friendly_filename(name)}_#{normalized_source_filename}"
      end
    end
  end
end
