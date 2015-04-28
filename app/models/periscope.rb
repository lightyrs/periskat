class Periscope < ActiveRecord::Base

  attr_accessible :secure_playlist_url, :playlist_url, :url, :channel,
                  :twitter_tweet_id, :twitter_tweet_text, :twitter_tweet_url,
                  :twitter_tweet_source

  validates :url, presence: true, uniqueness: true
end
