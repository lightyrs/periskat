require 'http'

class TwitterClient

  def initialize
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
        yield(object)
      end
    end
  end
end
