class MeerkatPopulator

  def parse_and_persist(tweet)
    expanded_url = expand_mrktv_url(tweet.uris)
    return unless expanded_url.present? && expanded_url != "http://"

    resource = resource_from_url(expanded_url)
    return if resource["error"].present?

    broadcaster  = find_or_create_broadcaster(tweet, resource)
    meerkat      = Meerkat.new

    meerkat.external_id          = resource["result"]["id"]
    meerkat.playlist_url         = resource["followupActions"].try(:[], "playlist")
    meerkat.place                = resource["result"]["place"]
    meerkat.location             = resource["result"]["location"]
    meerkat.cover_images         = resource["result"]["coverImages"] || []
    meerkat.cover                = resource["result"]["cover"]
    meerkat.likes_count          = resource["result"]["likesCount"]
    meerkat.comments_count       = resource["result"]["commentsCount"]
    meerkat.restreams_count      = resource["result"]["restreamsCount"]
    meerkat.watchers_count       = resource["result"]["watchersCount"]
    meerkat.end_time             = parse_end_time(resource["result"]["endTime"])
    meerkat.caption              = resource["result"]["caption"]
    meerkat.status               = resource["result"]["status"]
    meerkat.twitter_tweet_id     = resource["result"]["tweetId"]
    meerkat.twitter_tweet_text   = tweet.text
    meerkat.twitter_tweet_url    = "#{tweet.uri}"
    meerkat.twitter_tweet_source = tweet.source
    meerkat.url                  = expanded_url
    meerkat.broadcaster_id       = broadcaster.id

    meerkat.save
  rescue => e
    puts "#{e.class} #{e.message}".inspect.red
  end

  private

  def find_or_create_broadcaster(tweet, resource)
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
    broadcaster.meerkat_user_id              = resource["result"]["broadcaster"]["id"]
    broadcaster.meerkat_user_profile_url     = resource["result"]["broadcaster"]["profile"]

    return broadcaster if broadcaster.save
  end

  def expand_mrktv_url(urls)
    Unshorten[pluck_meerkat_url(urls)]
  end

  def resource_from_url(url)
    puts url.inspect.yellow
    resource_id = url.match(/.*\/(.*)\?/)[1]
    body        = HTTP.get(meerkat_resource_url(resource_id)).body.to_s

    Oj.load(body)
  rescue => e
    puts "#{e.class} #{e.message}".inspect.red
  end

  def pluck_meerkat_url(uris)
    meerkat_url = uris.detect { |uri| uri.expanded_url.to_s.match(/mrk\.tv/) }
    meerkat_url.present? ? meerkat_url.expanded_url.to_s : ''
  end

  def parse_end_time(end_time)
    end_time > 0 ? Time.at(end_time) : nil
  end

  def meerkat_resource_url(resource_id)
    "http://resources.meerkatapp.co/broadcasts/#{resource_id}/summary"
  end
end
