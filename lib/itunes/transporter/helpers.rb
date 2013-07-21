require 'yaml'
require 'itunes/transporter'

module Itunes
  module Transporter
    module Helpers
      def metadata_from_yaml(yaml_file)
        objs = YAML.load_file(Dir.pwd + "/#{yaml_file}")

        return {
          :provider => objs['provider'],
          :team_id => objs['team_id'],
          :vendor_id => objs['vendor_id'],
          :id_prefix => objs['id_prefix'] || '',
          :versions => parse_versions(objs),
          :default_achievement_image => objs['default_achievement_image'],
          :achievements => parse_achievements(objs),
          :leaderboards => parse_leaderboards(objs),
          :purchases => parse_purchases(objs)
        }
      end

      def parse_versions(objs)

        return unless objs.has_key?('versions')

        [].tap do |versions|
          objs['versions'].each do |dict|
            version = Version.new
            version.name = dict['name']
            version.locales = []

            dict['locales'].each do |loc|
              locale = VersionLocale.new
              locale.name = loc['name']
              locale.title = loc['title']
              locale.description = loc['description']
              locale.keywords = loc['keywords']
              locale.version_whats_new = loc['version_whats_new']
              locale.software_url = loc['software_url']
              locale.privacy_url = loc['privacy_url']
              locale.support_url = loc['support_url']
              locale.screenshots = []

              loc['screenshots'].each do |scrshot|
                screenshot = VersionScreenshot.new
                screenshot.display_target = scrshot['display_target']
                screenshot.file_name = scrshot['file_name']

                locale.screenshots << screenshot
              end

              version.locales << locale
            end

            versions << version
          end
        end
      end

      def parse_achievements(objs)
        achievements = []
        
        if objs.has_key?('achievements')
          objs['achievements'].each do |dict|
            achievement = Achievement.new
            achievement.id = dict['id']
            achievement.name = dict['name']
            achievement.points = dict['points']
            achievement.hidden = dict['has_key'] || false
            achievement.reusable = dict['reusable'] || false
            achievement.should_remove = dict['should_remove'] || false
            achievement.locales = []

            dict['locales'].each do |loc|
              locale = AchievementLocale.new
              locale.name = loc['name']
              locale.title = loc['title']
              locale.before_earned_description = loc['before_earned_description']
              locale.after_earned_description = loc['after_earned_description']
              locale.achievement_after_earned_image = loc['achievement_after_earned_image']
              locale.should_remove = loc['should_remove'] || false

              achievement.locales << locale
            end

            achievements << achievement
          end
        end
        achievements  
      end

      def parse_leaderboards(objs)
        leaderboards = []

        if objs.has_key?('leaderboards')
          objs['leaderboards'].each do |dict|
            leaderboard = Leaderboard.new
            leaderboard.default = dict['default']
          leaderboard.id = dict['id']
            leaderboard.name = dict['name']
            leaderboard.aggregate_parent_leaderboard = dict['aggregate_parent_leaderboard']
            leaderboard.sort_ascending = dict['sort_ascending'] || false
            leaderboard.score_range_min = dict['score_range_min']
            leaderboard.score_range_max = dict['score_range_max']
            leaderboard.locales = []

            dict['locales'].each do |loc|
              locale = LeaderboardLocale.new
              locale.name = loc['name']
              locale.title = loc['title']
              locale.formatter_suffix = loc['formatter_suffix']
              locale.formatter_suffix_singular = loc['formatter_suffix_singular']
              locale.formatter_type = loc['formatter_type']
              locale.leaderboard_image = loc['leaderboard_image']
              locale.should_remove = loc['should_remove'] || false

              leaderboard.locales << locale
            end

            leaderboards << leaderboard
          end
        end

        leaderboards
      end

      def parse_auto_renewables(auto_renewables)
        return nil if auto_renewables == nil

        fam = auto_renewables['family']
        family = Family.new
        family.name = fam['name']
        family.review_screenshot_image = fam['review_screenshot_image']
        family.review_notes = fam['review_notes']
        family.purchases = []
        family.locales = []

        # process all purchases in this family
        fam['purchases'].each do |pur|
          purchase = InAppPurchase.new
          purchase.product_id = pur['product_id']
          purchase.type = pur['type']
          purchase.duration = pur['duration']
          purchase.free_trial_duration = pur['free_trial_duration']
          purchase.bonus_duration = pur['bonus_duration']
          purchase.products = []
          purchase.locales = []

          product = Product.new
          product.cleared_for_sale = pur['cleared_for_sale']
          product.wholesale_price_tier = pur['wholesale_price_tier']
          product.intervals = []
          purchase.products << product

          family.purchases << purchase
        end

        # process all locales for this family
        fam['locales'].each do |loc|
          locale = PurchaseLocale.new
          locale.name = loc['name']
          locale.title = loc['title']
          locale.description = loc['description']
          locale.publication_name = loc['publication_name']

          family.locales << locale
        end

        family
      end

      def parse_other_purchases(other_purchases)
        return nil if other_purchases == nil

        purchases = []

        other_purchases.each do |pur|
          purchase = InAppPurchase.new
          purchase.product_id = pur['product_id']
          purchase.reference_name = pur['reference_name']
          purchase.type = pur['type']
          purchase.review_screenshot_image = pur['review_screenshot_image']
          purchase.review_notes = pur['review_notes']
          purchase.should_remove = pur['should_remove'] || false
          purchase.locales = []
          purchase.products = []

          intervals = pur['intervals'] || []

          product = Product.new
          product.cleared_for_sale = pur['cleared_for_sale']
          product.wholesale_price_tier = pur['wholesale_price_tier'] if intervals.count == 0
          product.should_remove = pur['should_remove'] || false
          product.intervals = []

          intervals.each do |i|
            interval = Interval.new
            interval.start_date = i['start_date']
            interval.end_date = i['end_date']
            interval.wholesale_price_tier = i['wholesale_price_tier']

            product.intervals << interval
          end

          purchase.products << product

          pur['locales'].each do |loc|
            locale = PurchaseLocale.new
            locale.name = loc['name']
            locale.title = loc['title']
            locale.description = loc['description']
            locale.publication_name = loc['publication_name']

            purchase.locales << locale
          end

          purchases << purchase
        end

        purchases
      end

      def parse_purchases(objs)
        purchases = {}

        if objs.has_key?('purchases')
          all_purchases = objs['purchases']

          purchases = {
            :auto_renewable_purchase_family => parse_auto_renewables(all_purchases['auto_renewable_purchases']),
            :other_purchases => parse_other_purchases(all_purchases['other_purchases'])
          }
        end

        purchases
      end
    end
  end
end
