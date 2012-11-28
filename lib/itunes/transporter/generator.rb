require 'builder'
require 'digest'
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
		
			def initialize(options)
				@files_to_process = ['metadata.xml']
				
				config_file = options.i || options.input

				metadata = metadata_from_yaml(config_file)

				@id_prefix = metadata[:id_prefix]
				@provider = metadata[:provider]
				@team_id = metadata[:team_id]
				@vendor_id = metadata[:vendor_id]
				@achievements = metadata[:achievements]
				@leaderboards = metadata[:leaderboards]
				@purchases = metadata[:purchases]
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
								doc.after_earned_image() do
									image_path = Dir.pwd + "/#{locale.after_earned_image}"
									@files_to_process << image_path
						
									doc.file_name(locale.after_earned_image)
									doc.size(File.size?(image_path))
									doc.checksum(Digest::MD5.file(image_path).hexdigest, 'type' => 'md5')
								end
							end
						end
					end
				end
			end
		
			def create_leaderboard_xml(doc, leaderboard, position)
				doc.leaderboard('default' => leaderboard.default, 'position' => position) do
					doc.leaderboard_id(leaderboard.id)
					doc.reference_name(leaderboard.name)
		
					if leaderboard.aggregate_parent_leaderboard
						doc.aggregate_parent_leaderboard(leaderboard.aggregate_parent_leaderboard)
					end
		
					doc.sort_ascending(leaderboard.sort_ascending)
		
					if (doc.score_range_min != doc.score_range_max)
						doc.score_range_min(leaderboard.score_range_min)
						doc.score_range_max(leaderboard.score_range_max)			
					end
		
					doc.locales() do
						leaderboard.locales.each do |locale|
							doc.locale('name' => locale.name) do
								doc.title(locale.title)
					
								if (locale.formatter_suffix)
									doc.formatter_suffix(locale.formatter_suffix)
								end
					
								if (locale.formatter_suffix_singular)
									doc.formatter_suffix_singular(locale.formatter_suffix_singular)
								end
					
								doc.formatter_type(locale.formatter_type)
								doc.leaderboard_image() do
									image_path = Dir.pwd + "/#{locale.leaderboard_image}"
									@files_to_process << image_path
						
									doc.file_name(locale.leaderboard_image)
									doc.size(File.size?(image_path))
									doc.checksum(Digest::MD5.file(image_path).hexdigest, 'type' => 'md5')									
								end
							end				
						end
					end
				end
			end
		
			def create_purchase_xml(doc, purchase)
				doc.in_app_purchase() do
					doc.product_id(@id_prefix + purchase.product_id)
					doc.reference_name(purchase.reference_name)
					doc.type(purchase.type)
				
					doc.products() do
						purchase.products.each do |product|
							doc.product() do
								doc.cleared_for_sale(product.cleared_for_sale)
								doc.wholesale_price_tier(product.wholesale_price_tier)
							end
						end
					end
				
					doc.locales() do
						purchase.locales.each do |locale|
							doc.locale('name' => locale.name) do
								doc.title(locale.title)
								doc.description(locale.description)
							end
						end
					end
				
					doc.review_screenshot() do
						image_path = Dir.pwd + "/#{purchase.review_screenshot_image}"
						@files_to_process << image_path
						
						doc.file_name(purchase.review_screenshot_image)
						doc.size(File.size?(image_path))
						doc.checksum(Digest::MD5.file(image_path).hexdigest, 'type' => 'md5')		
					end
				end
			end

			def generate_metadata		
				metadata_file = File.new(Dir.pwd + '/metadata.xml', 'w')
				
				doc = Builder::XmlMarkup.new(:target => metadata_file, :indent => 2)
				doc.instruct!(:xml, :version => '1.0', :encoding => 'UTF-8')
				doc.package('xmlns' => 'http://apple.com/itunes/importer', 'version' => 'software5.0') do
					doc.provider(@provider)
					doc.team_id(@team_id)
					doc.software() do
						doc.vendor_id(@vendor_id)
						doc.software_metadata() do
							doc.game_center() do
								if (@achievements.count > 0)
									doc.achievements() do
										@achievements.each_with_index do |val, index|
											create_achievement_xml(doc, val, index + 1)
										end
									end
								end
							
								if (@leaderboards.count > 0)
									doc.leaderboards() do
										@leaderboards.each_with_index do |val, index|
											create_leaderboard_xml(doc, val, index + 1)
										end
									end
								end
							
								if (@purchases.count > 0)
									doc.in_app_purchases() do
										@purchases.each do |val|
											create_purchase_xml(doc, val)
										end
									end
								end
							end
						end
					end
				end

				metadata_file.close()			
			end	
		
			def generate_itmsp
				itmsp_dir = @vendor_id + '.itmsp'
				Dir.mkdir(itmsp_dir)
			
				@files_to_process.each do |file|
					FileUtils.cp(file, itmsp_dir)
				end
			end
		end
	end
end