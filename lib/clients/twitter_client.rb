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
        parse_and_persist(object)
      end
    end
  end

  private

  def parse_and_persist(object)
    puts object.inspect.blue
    # periscope                          = Periscope.new
    periscope = {
      url:                      pluck_periscope_url(object.uris),
      twitter_tweet_id:         object.id,
      twitter_tweet_text:       object.text,
      twitter_tweet_url:        "#{object.uri}",
      twitter_tweet_source:     object.source,
      twitter_user_id:          object.user.id,
      twitter_user_name:        object.user.name,
      twitter_user_screen_name: object.user.screen_name,
      twitter_user_avatar:      "#{object.user.profile_image_uri}",
      twitter_user_profile_url: "#{object.user.uri}",
      twitter_user_bio:         object.user.description
    }

    puts periscope.inspect.red

    playlist_urls                   = scrape_playlist_urls(periscope[:url])
    periscope[:playlist_url]        = playlist_urls[:http]
    periscope[:secure_playlist_url]  = playlist_urls[:https]

    puts periscope.inspect.green

    Periscope.create(periscope)
  end

  def pluck_periscope_url(uris)
    periscope_url = uris.detect { |uri| uri.expanded_url.to_s.match(/periscope/) }
    periscope_url.present? ? periscope_url.expanded_url.to_s : ''
  end

  def scrape_playlist_urls(source_url)
    periscope_url = "https://api.periscope.tv/api/v2/getAccessPublic?token=#{source_url.split('.tv/w/')[1]}"

    puts periscope_url.inspect.blue

    body = HTTP.get(periscope_url).body.to_s

    puts body.inspect.yellow

    parsed_body = Oj.load(body)

    puts parsed_body.inspect.blue

    {
      http: parsed_body["hls_url"],
      https: parsed_body["https_hls_url"]
    }
  rescue => e
    puts "#{e.class}: #{e.message}".inspect.red
    { http: '', https: '' }
  end
end
