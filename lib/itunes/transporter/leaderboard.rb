module Itunes
  module Transporter
    class Leaderboard < Struct.new(:default, :id, :name, :aggregate_parent_leaderboard, :sort_ascending, :score_range_min, :score_range_max, :locales)
    end

    class LeaderboardLocale < Struct.new(:name, :title, :formatter_suffix, :formatter_suffix_singular, :formatter_type, :leaderboard_image, :should_remove)
    end
  end
end