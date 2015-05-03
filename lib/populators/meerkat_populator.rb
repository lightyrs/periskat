class MeerkatPopulator

  def self.run
    response_hash = MeerkatClient.new.broadcasts
    persist_broadcasters(response_hash[:broadcasters])
    persist_broadcasts(response_hash[:broadcasts])
  end

  private

  def self.persist_broadcasts(broadcasts)
    broadcasts.each do |broadcast|
      record             = Meerkat.new(map_broadcast_response(broadcast))
      record.broadcaster = Broadcaster.find_by(twitter_user_id: user_id_by_tweet_id(record.twitter_tweet_id))
      record.save unless record.broadcaster.nil?
    end
  end

  def self.persist_broadcasters(broadcasters)
    @broadcasters = broadcasters
    broadcasters.each do |broadcaster|
      Broadcaster.create(map_broadcaster_response(broadcaster))
    end
  end

  def self.map_broadcast_response(response)
    {
      external_id:      response["result"]["id"],
      cover:            response["result"]["cover"],
      caption:          response["result"]["caption"],
      latitude:         nil,
      longitude:        nil,
      location_string:  response["result"]["location"],
      place_name:       response["result"]["place"],
      watchers_count:   response["result"]["watchersCount"],
      comments_count:   response["result"]["commentsCount"],
      likes_count:      response["result"]["likesCount"],
      restreams_count:  response["result"]["restreamsCount"],
      cover_images:     (response["result"]["coverImages"] || []),
      status:           response["result"]["status"],
      end_time:         parse_end_time(response["result"]["endTime"]),
      twitter_tweet_id: "#{response['result']['tweetId']}",
      playlist_url:     response["followupActions"].try(:[], "playlist"),
      url:              meerkat_url(response["result"]["id"], response["result"]["broadcaster"])
    }
  end

  def self.map_broadcaster_response(response)
    response = response[:tweet_user]
    {
      twitter_user_id: response.id,
      twitter_user_name: response.name,
      twitter_user_screen_name: response.screen_name,
      twitter_user_avatar: "#{response.profile_image_uri}",
      twitter_user_banner_url: "#{response.profile_banner_uri}",
      twitter_user_profile_url: "#{response.uri}",
      twitter_user_bio: response.description,
      twitter_user_following_count: response.friends_count,
      twitter_user_followers_count: response.followers_count,
      twitter_user_location: response.location
    }
  end

  def self.user_id_by_tweet_id(tweet_id)
    b = @broadcasters.detect { |broadcaster| "#{broadcaster[:tweet_id]}" == "#{tweet_id}" }
    "#{b[:tweet_user].id}" rescue ''
  end

  def self.meerkat_url(broadcast_id, broadcaster)
    "http://meerkatapp.co/#{broadcaster['name']}/#{broadcast_id}"
  end

  def self.parse_end_time(end_time)
    end_time > 0 ? Time.at(end_time) : nil
  end
end
