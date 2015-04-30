class Periscope < Ohm::Model
  include Ohm::Timestamps

  attribute :url
  unique    :url

  attribute :playlist_url
  attribute :secure_playlist_url
  attribute :twitter_tweet_id
  attribute :twitter_tweet_text
  attribute :twitter_tweet_url
  attribute :twitter_tweet_source
  attribute :twitter_user_id
  attribute :twitter_user_name
  attribute :twitter_user_screen_name
  attribute :twitter_user_avatar
  attribute :twitter_user_profile_url
  attribute :twitter_user_bio
  attribute :twitter_user_followers_count
  attribute :twitter_user_following_count
end
