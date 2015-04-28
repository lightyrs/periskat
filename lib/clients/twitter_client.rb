require 'redis'

class TwitterClient

  def initialize
    @redis  = Redis.new
    @client = Twitter::Streaming::Client.new do |config|
      config.consumer_key        = "lOS9lsS7xOwW0p5tVK7uNN24o"
      config.consumer_secret     = "kK8pYW13qzQJyMrjMq41HNiJKkALg2SVJUsPtPWJqupPhoDjLX"
      config.access_token        = "14280068-0hWXYBe3qnlPiAKNls9VG9LOLQrC3ldGPxLsBHWaX"
      config.access_token_secret = "AjbTOqu1u8lNbgl9ZshyUjWGZS0rlPeQ1csBQEl1CzAG2"
    end
  end

  def filter_stream
    @client.filter(track: "#Periscope") do |object|
      if object.is_a?(Twitter::Tweet) && object.text.match(/LIVE on #Periscope/i).present?
        periscope = {
          twitter_tweet_id: object.id,
          twitter_tweet_text: object.text,
          twitter_tweet_url: "#{object.uri}",
          twitter_tweet_source: object.source,
          twitter_favorite_count: object.favorite_count,
          twitter_retweet_count: object.retweet_count,
          twitter_user_id: object.user.id,
          twitter_user_screen_name: object.user.screen_name,
          url: pluck_periscope_url(object.uris)
        }
        @redis.set("#{object.id}", Oj.dump(periscope))
        @redis.expire("#{object.id}", 300)
      end
    end
  end

  private

  def pluck_periscope_url(uris)
    periscope_url = uris.detect { |uri| uri.expanded_url.to_s.match(/periscope/) }
    periscope_url.expanded_url.to_s
  end
end
