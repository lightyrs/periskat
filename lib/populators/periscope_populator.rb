class PeriscopePopulator

  def parse_and_persist(tweet)
    broadcaster = find_or_create_broadcaster(tweet)
    periscope   = Periscope.new

    periscope.url                  = pluck_periscope_url(tweet.uris)
    periscope.twitter_tweet_id     = tweet.id
    periscope.twitter_tweet_text   = tweet.text
    periscope.twitter_tweet_url    = "#{tweet.uri}"
    periscope.twitter_tweet_source = tweet.source

    playlist_urls                  = scrape_playlist_urls(periscope.url)
    periscope.playlist_url         = playlist_urls[:http]
    periscope.secure_playlist_url  = playlist_urls[:https]
    periscope.broadcaster_id       = broadcaster.id

    puts periscope.url.inspect.green

    periscope.save
  rescue => e
    puts "#{e.class} #{e.message}".inspect.red
  end

  private

  def find_or_create_broadcaster(tweet)
    broadcaster = Broadcaster.find(twitter_user_id: "#{tweet.user.id}")

    if broadcaster.any?
      return broadcaster.to_a.pop
    else
      broadcaster = Broadcaster.new
    end

    broadcaster.twitter_user_id              = "#{tweet.user.id}"
    broadcaster.twitter_user_name            = tweet.user.name
    broadcaster.twitter_user_screen_name     = tweet.user.screen_name
    broadcaster.twitter_user_avatar          = "#{tweet.user.profile_image_uri}"
    broadcaster.twitter_user_banner_url      = "#{tweet.user.profile_banner_uri}"
    broadcaster.twitter_user_profile_url     = "#{tweet.user.uri}"
    broadcaster.twitter_user_bio             = tweet.user.description
    broadcaster.twitter_user_following_count = tweet.user.friends_count
    broadcaster.twitter_user_followers_count = tweet.user.followers_count
    broadcaster.twitter_user_location        = tweet.user.location

    return broadcaster if broadcaster.save
  end

  def pluck_periscope_url(uris)
    periscope_url = uris.detect { |uri| uri.expanded_url.to_s.match(/periscope/) }
    periscope_url.present? ? periscope_url.expanded_url.to_s : ''
  end

  def scrape_playlist_urls(source_url)
    periscope_url = "https://api.periscope.tv/api/v2/getAccessPublic?token=#{source_url.split('.tv/w/')[1]}"

    body = HTTP.get(periscope_url).body.to_s

    return default_playlist_urls if body.match(/^gone/i)

    parsed_body = Oj.load(body)

    {
      http: parsed_body["hls_url"],
      https: parsed_body["https_hls_url"]
    }
  rescue => e
    puts "#{e.class} #{e.message}".inspect.red
    default_playlist_urls
  end

  def default_playlist_urls
    { http: '', https: '' }
  end
end
