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

  reference :broadcaster, :Broadcaster
end
