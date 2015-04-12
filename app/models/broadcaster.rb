class Broadcaster < ActiveRecord::Base

  attr_accessible :external_id, :username, :display_name, :avatar_url,
                  :avatar_thumbnail_url, :profile_url, :twitter_user_id,
                  :privacy, :bio, :streams_count, :following_count,
                  :followers_count, :score

  validates :external_id, presence: true, uniqueness: true

  has_many :meerkats
end
