class Meerkat < Ohm::Model
  include Ohm::Timestamps

  attribute :url
  unique    :url

  attribute :external_id
  attribute :playlist_url
  attribute :place
  attribute :location
  attribute :cover
  attribute :cover_images
  attribute :likes_count
  attribute :comments_count
  attribute :restreams_count
  attribute :watchers_count
  attribute :end_time
  attribute :caption
  attribute :status
  attribute :twitter_tweet_id
  attribute :twitter_tweet_text
  attribute :twitter_tweet_url
  attribute :twitter_tweet_source

  reference :broadcaster, :Broadcaster
end
