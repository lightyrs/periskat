class Broadcaster < ActiveRecord::Base

  attr_accessible :twitter_user_id, :twitter_user_name, :twitter_user_screen_name,
                  :twitter_user_avatar, :twitter_user_profile_url, :twitter_user_bio,
                  :twitter_user_following_count, :twitter_user_followers_count,
                  :twitter_user_location, :twitter_user_banner_url

  validates :twitter_user_id, presence: true, uniqueness: true

  has_many :meerkats
end
