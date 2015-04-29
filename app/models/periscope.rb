class Periscope
  include ActiveModel::AttributeMethods
  include ActiveModel::Validations
  include ActiveModel::Model
  include Redis::Objects

  def id
    self.twitter_tweet_id
  end

  redis_id_field :twitter_tweet_id

  value :url, :expiration => 10.minutes
  value :playlist_url, :expiration => 10.minutes
  value :secure_playlist_url, :expiration => 10.minutes
  value :twitter_tweet_id, :expiration => 10.minutes
  value :twitter_tweet_text, :expiration => 10.minutes
  value :twitter_tweet_url, :expiration => 10.minutes
  value :twitter_tweet_source, :expiration => 10.minutes
  value :twitter_user_id, :expiration => 10.minutes
  value :twitter_user_name, :expiration => 10.minutes
  value :twitter_user_screen_name, :expiration => 10.minutes
  value :twitter_user_avatar, :expiration => 10.minutes
  value :twitter_user_profile_url, :expiration => 10.minutes
  value :twitter_user_bio, :expiration => 10.minutes
  value :twitter_user_followers_count, :expiration => 10.minutes
  value :twitter_user_following_count, :expiration => 10.minutes

  define_attribute_methods 'twitter_tweet_id', 'url', 'playlist_url', 'secure_playlist_url',
                           'twitter_user_id', 'twitter_tweet_text', 'twitter_tweet_url',
                           'twitter_tweet_source', 'twitter_user_id', 'twitter_user_name',
                           'twitter_user_screen_name', 'twitter_user_avatar',
                           'twitter_user_profile_url', 'twitter_user_bio',
                           'twitter_user_followers_count', 'twitter_user_following_count'

  attr_accessor   :twitter_tweet_id, :url, :playlist_url, :secure_playlist_url,
                  :twitter_user_id, :twitter_tweet_text, :twitter_tweet_url,
                  :twitter_tweet_source, :twitter_user_id, :twitter_user_name,
                  :twitter_user_screen_name, :twitter_user_avatar,
                  :twitter_user_profile_url, :twitter_user_bio,
                  :twitter_user_followers_count, :twitter_user_following_count

  validates :url, presence: true, uniqueness: true
end
