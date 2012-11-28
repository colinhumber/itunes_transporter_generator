require 'yaml'
require 'itunes/transporter/achievement'
require 'itunes/transporter/leaderboard'
require 'itunes/transporter/in_app_purchase'

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
          :achievements => parse_achievements(objs), 
          :leaderboards => parse_leaderboards(objs), 
          :purchases => parse_purchases(objs) 
        }
      end
      
      def parse_achievements(objs)
        achievements = []
        
        objs['achievements'].each do |dict|
          achievement = Achievement.new
          achievement.id = dict['id']
          achievement.name = dict['name']
          achievement.points = dict['points']
          achievement.hidden = dict.has_key?('hidden') ? dict['has_key'] : false
          achievement.reusable = dict.has_key?('reusable') ? dict['reusable'] : false
          achievement.should_remove = dict.has_key?('should_remove') ? dict['should_remove'] : false
          achievement.locales = []
              
          dict['locales'].each do |loc|
            locale = AchievementLocale.new
            locale.name = loc['name']
            locale.title = loc['title']
            locale.before_earned_description = loc['before_earned_description']
            locale.after_earned_description = loc['after_earned_description']
            locale.after_earned_image = loc['after_earned_image']
            locale.should_remove = loc.has_key?('should_remove') ? loc['should_remove'] : false
            
            achievement.locales << locale
          end

          achievements << achievement         
        end

        achievements  
      end
      
      def parse_leaderboards(objs)
        leaderboards = []
        
        objs['leaderboards'].each do |dict|
          leaderboard = Leaderboard.new
          leaderboard.default = dict['default']
          leaderboard.name = dict['name']
          leaderboard.aggregate_parent_leaderboard = dict['aggregate_parent_leaderboard']
          leaderboard.sort_ascending = dict.has_key?('sort_ascending') ? dict['sort_ascending'] : false
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
            locale.should_remove = loc.has_key?('should_remove') ? loc['should_remove'] : false
            
            leaderboard.locales << locale
          end
          
          leaderboards << leaderboard
        end
        
        leaderboards
      end
      
      def parse_purchases(objs)     
        purchases = []
        
        objs['purchases'].each do |dict|
          purchase = InAppPurchase.new
          purchase.product_id = dict['product_id']
          purchase.reference_name = dict['reference_name']
          purchase.type = dict['type']
          purchase.duration = dict['duration']
          purchase.free_trial_duration = dict['free_trial_duration']
          purchase.bonus_duration = dict['bonus_duration']
          purchase.review_screenshot_image = dict['review_screenshot_image']
          purchase.review_notes = dict['review_notes']
          purchase.should_remove = dict.has_key?('should_remove') ? dict['should_remove'] : false
          purchase.locales = []
          purchase.products = []
              
          dict['products'].each do |p|
            product = Product.new
            product.cleared_for_sale = p['cleared_for_sale']
            product.wholesale_price_tier = p['wholesale_price_tier']
            product.should_remove = dict.has_key?('should_remove') ? dict['should_remove'] : false
            product.intervals = []
            
            intervals = p['intervals']
            if intervals
              p['intervals'].each do |i|
                interval = Interval.new
                interval.start_date = i['start_date']
                interval.end_date = i['end_date']
                interval.wholesale_price_tier = i['wholesale_price_tier']
              
                product.intervals << interval
              end
            end
            
            purchase.products << product
          end
          
          dict['locales'].each do |loc|
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
      
    end
  end
end
