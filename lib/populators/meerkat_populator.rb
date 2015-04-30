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
      record.broadcaster = Broadcaster.find_by(external_id: broadcast["result"]["broadcaster"]["id"])
      record.save
    end
  end

  def self.persist_broadcasters(broadcasters)
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
    {
      external_id:          response["result"]["info"]["id"],
      username:             response["result"]["info"]["username"],
      display_name:         response["result"]["info"]["displayName"],
      avatar_url:           response["followupActions"]["profileImage"],
      avatar_thumbnail_url: response["followupActions"]["profileThumbImage"],
      profile_url:          nil,
      twitter_user_id:      response["result"]["info"]["twitterId"],
      privacy:              response["result"]["info"]["privacy"],
      bio:                  response["result"]["info"]["bio"],
      streams_count:        response["result"]["stats"]["streamsCount"],
      following_count:      response["result"]["stats"]["followingCount"],
      followers_count:      response["result"]["stats"]["followersCount"],
      score:                response["result"]["stats"]["score"]
    }
  end

  def self.meerkat_url(broadcast_id, broadcaster)
    "http://meerkatapp.co/#{broadcaster['name']}/#{broadcast_id}"
  end

  def self.parse_end_time(end_time)
    end_time > 0 ? Time.at(end_time) : nil
  end
end
