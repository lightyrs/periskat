require 'http'

class TwitterClient

  def initialize(api = :rest)
    @client = api == :rest ? rest_client : streaming_client
  end

  def filter_stream
    @client.filter(track: "#Periscope") do |object|
      if object.is_a?(Twitter::Tweet) && object.text.match(/LIVE on #Periscope/i).present?
        yield(object)
      end
    end
  end

  def tweets(tweet_ids)
    @client.statuses(tweet_ids)
  end

  private

  def streaming_client
    Twitter::Streaming::Client.new do |config|
      config.consumer_key        = TWITTER_CONSUMER_KEY
      config.consumer_secret     = TWITTER_CONSUMER_SECRET
      config.access_token        = TWITTER_ACCESS_TOKEN
      config.access_token_secret = TWITTER_ACCESS_TOKEN_SECRET
    end
  end

  def rest_client
    Twitter::REST::Client.new do |config|
      config.consumer_key        = TWITTER_CONSUMER_KEY
      config.consumer_secret     = TWITTER_CONSUMER_SECRET
      config.access_token        = TWITTER_ACCESS_TOKEN
      config.access_token_secret = TWITTER_ACCESS_TOKEN_SECRET
    end
  end
end
