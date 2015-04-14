class Meerkat < ActiveRecord::Base

  attr_accessible :external_id, :playlist_url, :place_name, :location_string,
                  :latitude, :longitude, :cover_images, :cover, :likes_count,
                  :comments_count, :restreams_count, :watchers_count, :end_time,
                  :caption, :status, :twitter_tweet_id, :url

  validates :external_id, presence: true, uniqueness: true

  belongs_to :broadcaster
end