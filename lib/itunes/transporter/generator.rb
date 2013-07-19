require 'builder'
require 'digest'
require 'fileutils'
require 'itunes/transporter/helpers'

module Itunes
  module Transporter
    class Generator
      include Itunes::Transporter::Helpers

      attr_reader :files_to_process
      attr_accessor :id_prefix
      attr_accessor :provider
      attr_accessor :team_id
      attr_accessor :vendor_id
      attr_accessor :achievements
      attr_accessor :leaderboards
      attr_accessor :purchases
      attr_accessor :output
      attr_accessor :versions

      def initialize(options)
        @files_to_process = ['metadata.xml']

        config_file = options.i || options.input

        metadata = metadata_from_yaml(config_file)

        @id_prefix = metadata[:id_prefix]
        @provider = metadata[:provider]
        @team_id = metadata[:team_id]
        @vendor_id = metadata[:vendor_id].to_s
        @achievements = metadata[:achievements]
        @leaderboards = metadata[:leaderboards]
        @purchases = metadata[:purchases]
        @default_achievement_image = metadata[:default_achievement_image]
        @versions = metadata[:versions]
        @output = { :messages => [], :errors => [] }
      end

      def create_version_xml(doc, version)
        doc.version('string' => version.name) do
          doc.locales() do

            version.locales.each do |locale|
              doc.locale('name' => locale.name) do
                doc.title(locale.title)
                doc.description(locale.description)

                doc.keywords() do
                  locale.keywords.each do |keyword|
                    doc.keyword(keyword)
                  end
                end

                doc.version_whats_new(locale.version_whats_new)
                doc.software_url(locale.software_url)
                doc.privacy_url(locale.privacy_url)
                doc.support_url(locale.support_url)

                doc.software_screenshots() do
                  locale.screenshots.each_with_index do |screenshot, index|
                    doc.software_screenshot('display_target' => screenshot.display_target, 'position' => index + 1) do
                      create_screenshot_xml(doc, screenshot.file_name)
                    end
                  end
                end
              end
            end
          end
        end
      end

      def create_achievement_xml(doc, achievement, position)
        doc.achievement('position' => position) do
          doc.achievement_id(@id_prefix + achievement.id)
          doc.reference_name(achievement.name)
          doc.points(achievement.points)
          doc.hidden(achievement.hidden)
          doc.reusable(achievement.reusable)
          doc.locales() do
            achievement.locales.each do |locale|
              doc.locale('name' => locale.name) do
                doc.title(locale.title)
              doc.before_earned_description(locale.before_earned_description)
                doc.after_earned_description(locale.after_earned_description)
                doc.achievement_after_earned_image() do
                  create_screenshot_xml(doc, locale.achievement_after_earned_image || @default_achievement_image)
                end
              end
            end
          end
        end
      end

      def create_leaderboard_xml(doc, leaderboard, position)
        doc.leaderboard('default' => leaderboard.default, 'position' => position) do
          doc.leaderboard_id(@id_prefix + leaderboard.id)
          doc.reference_name(leaderboard.name)

          if leaderboard.aggregate_parent_leaderboard
            doc.aggregate_parent_leaderboard(leaderboard.aggregate_parent_leaderboard)
          end

          doc.sort_ascending(leaderboard.sort_ascending)

          doc.score_range_min(leaderboard.score_range_min) if leaderboard.score_range_min
          doc.score_range_max(leaderboard.score_range_max) if leaderboard.score_range_max

          doc.locales() do
            leaderboard.locales.each do |locale|
              doc.locale('name' => locale.name) do
                doc.title(locale.title)

                doc.formatter_suffix(locale.formatter_suffix) if locale.formatter_suffix
                doc.formatter_suffix_singular(locale.formatter_suffix_singular) if locale.formatter_suffix_singular

                doc.formatter_type(locale.formatter_type)
                doc.leaderboard_image() do
                  create_screenshot_xml(doc, locale.leaderboard_image)
                end
              end
            end
          end
        end
      end

      def create_in_app_purchase_xml(doc, purchase)
        doc.in_app_purchase() do
          doc.product_id(@id_prefix + purchase.product_id)
          doc.reference_name(purchase.reference_name) if purchase.reference_name
          doc.duration(purchase.duration) if purchase.duration
          doc.free_trial_duration(purchase.free_trial_duration) if purchase.free_trial_duration
          doc.bonus_duration(purchase.bonus_duration) if purchase.bonus_duration

          doc.type(purchase.type)

          doc.products() do
            purchase.products.each do |product|
              doc.product() do
                doc.cleared_for_sale(product.cleared_for_sale)
                doc.wholesale_price_tier(product.wholesale_price_tier) if product.wholesale_price_tier

                doc.intervals() do
                  product.intervals.each do |interval|
                    doc.interval() do
                      doc.start_date(interval.start_date) if interval.start_date
                      doc.end_date(interval.end_date) if interval.end_date
                      doc.wholesale_price_tier(interval.wholesale_price_tier)
                    end
                  end
                end if product.intervals.count > 0
              end
            end
          end

          doc.locales() do
            purchase.locales.each do |locale|
              create_purchase_locale_xml(doc, locale)
            end
          end if purchase.locales.count > 0

          doc.review_screenshot() do
            create_screenshot_xml(doc, purchase.review_screenshot_image)
          end if purchase.review_screenshot_image
        end
      end

      def create_purchase_locale_xml(doc, locale)
        doc.locale('name' => locale.name) do
          doc.title(locale.title)
          doc.description(locale.description)
          doc.publication_name(locale.publication_name) if locale.publication_name
        end
      end

      def create_purchase_family_xml(doc, family)
        doc.family('name' => family.name) do
          doc.locales() do
            family.locales.each do |locale|
              create_purchase_locale_xml(doc, locale)
            end
          end

          doc.review_screenshot() do
            create_screenshot_xml(doc, family.review_screenshot_image)
          end

          doc.review_notes(family.review_notes)

          family.purchases.each do |purchase|
            create_in_app_purchase_xml(doc, purchase)
          end
        end
      end

      def create_screenshot_xml(doc, file_name)
        image_path = Dir.pwd + "/#{file_name}"
        @files_to_process << image_path

        doc.file_name(file_name)
        doc.size(File.size?(image_path))
        doc.checksum(Digest::MD5.file(image_path).hexdigest, 'type' => 'md5')
      end

      def create_other_purchases_xml(doc, purchases)
        purchases.each do |purchase|
          create_in_app_purchase_xml(doc, purchase)
        end
      end

      def generate_metadata
        metadata_file = File.new(Dir.pwd + '/metadata.xml', 'w')

        doc = Builder::XmlMarkup.new(:target => metadata_file, :indent => 2)
        doc.instruct!(:xml, :version => '1.0', :encoding => 'UTF-8')
        doc.package('xmlns' => 'http://apple.com/itunes/importer', 'version' => 'software5.0') do
          doc.provider(@provider) if @provider
          doc.team_id(@team_id) if @team_id
          doc.software() do
            doc.vendor_id(@vendor_id)
            doc.software_metadata() do

              if @versions.count > 0
                doc.versions() do
                  @versions.each do |version|
                    create_version_xml(doc, version)
                  end
                end
              end

              doc.game_center() do
                # generate XML for all achievements
                if @achievements.count > 0
                  doc.achievements() do
                    @achievements.each_with_index do |val, index|
                      create_achievement_xml(doc, val, index + 1)
                    end
                  end
                end

                # generate XML for all leaderboards
                if @leaderboards.count > 0
                  doc.leaderboards() do
                    @leaderboards.each_with_index do |val, index|
                      create_leaderboard_xml(doc, val, index + 1)
                    end
                  end
                end
              end

              # generate XML for all auto-renewable subscriptions and other IAPs (consumable, non-consumable, subscription, free-subscription)
              if @purchases.count > 0
                auto_renewable_purchase_family = @purchases[:auto_renewable_purchase_family]
                other_purchases = @purchases[:other_purchases]

                doc.in_app_purchases() do
                  create_purchase_family_xml(doc, auto_renewable_purchase_family) if auto_renewable_purchase_family
                  create_other_purchases_xml(doc, other_purchases) if other_purchases
                end
              end
            end
          end
        end

        metadata_file.close()

        generate_itmsp

        output
      end

      def generate_itmsp
          itmsp_dir = @vendor_id + '.itmsp'

        begin
          FileUtils.rm_rf(itmsp_dir) if Dir.exists?(itmsp_dir)
          Dir.mkdir(itmsp_dir)

          @files_to_process.each do |file|
            FileUtils.cp(file, itmsp_dir)
          end

          output[:messages] << "Successfully created iTunes metadata package: #{itmsp_dir}"
        rescue Exception => e
          output[:errors] << e.message
        end
      end
    end
  end
end
