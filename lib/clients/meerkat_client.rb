class MeerkatClient

  BROADCASTS_ENDPOINT = "http://channels.meerkatapp.co/broadcasts.json"

  def initialize(options = {})
    @hydra = Typhoeus::Hydra.new
  end

  def broadcasts
    @broadcasts = []
    request = Typhoeus::Request.new(BROADCASTS_ENDPOINT, followlocation: true)
    request.on_complete do |response|
      handle_response(response, :summaries)
    end
    @hydra.queue(request)
    @hydra.run
    { broadcasts: @broadcasts, broadcasters: broadcasters_from_tweets }
  end

  def broadcast(broadcast_id)
    @broadcast = {}
    request = Typhoeus::Request.new(broadcast_url(broadcast_id), followlocation: true)
    request.on_complete do |response|
      handle_response(response, :parse_object_response)
    end
    @hydra.queue(request)
    @hydra.run
    @broadcast
  end

  def broadcasters(broadcaster_ids)
    @broadcasters = []
    broadcaster_ids.each do |broadcaster_id|
      request = Typhoeus::Request.new(broadcaster_url(broadcaster_id), followlocation: true)
      request.on_complete do |response|
        handle_response(response, :populate_broadcasters)
      end
      @hydra.queue(request)
    end
    @hydra.run
    @broadcasters
  end

  def broadcasters_from_tweets
    @twitter_client = TwitterClient.new(:rest)
    tweets = @twitter_client.tweets(@broadcasts.map { |broadcast| broadcast["result"]["tweetId"] })
    tweets.map do |tweet|
      { tweet_id: tweet.id, tweet_user: tweet.user }
    end
  end

  def broadcaster(broadcaster_id)
    @broadcaster = {}
    request = Typhoeus::Request.new(broadcaster_url(broadcaster_id), followlocation: true)
    request.on_complete do |response|
      @broadcaster = handle_response(response, :parse_object_response)
    end
    @hydra.queue(request)
    @hydra.run
    @broadcaster
  end

  private

  def summaries(broadcasts_response)
    Oj.load(broadcasts_response.body).fetch("result", []).each do |result|
      request = Typhoeus::Request.new(result["broadcast"], followlocation: true)
      request.on_complete do |response|
        handle_response(response, :populate_broadcasts)
      end
      @hydra.queue(request)
    end
    @hydra.run
  end

  def populate_broadcasts(response)
    @broadcasts.push(parse_object_response(response))
  end

  def populate_broadcasters(response)
    @broadcasters.push(parse_object_response(response))
  end

  def parse_object_response(response)
    Oj.load(response.body)
  end

  def handle_response(response, callback)
    if response.success?
      self.send(callback, response)
    elsif response.timed_out?
      puts "request timed out".red
    elsif response.code == 0
      puts response.return_message.red
    else
      puts "HTTP request failed: #{response.code.to_s}"
    end
  end

  def broadcaster_url(broadcaster_id)
    "https://resources.meerkatapp.co/users/#{broadcaster_id}/profile?v=2"
  end

  def broadcast_url(broadcast_id)
    "http://resources.meerkatapp.co/broadcasts/#{broadcast_id}/summary"
  end
end
