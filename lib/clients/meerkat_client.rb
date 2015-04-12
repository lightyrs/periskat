class MeerkatClient

  BROADCASTS_ENDPOINT = "http://channels.meerkatapp.co/broadcasts.json"

  def initialize(options = {})
    @hydra = Typhoeus::Hydra.new
  end

  def broadcasts
    @broadcast_urls = []
    request = Typhoeus::Request.new(BROADCASTS_ENDPOINT, followlocation: true)
    request.on_complete do |response|
      if response.success?
        results = Oj.load(response.body).fetch("result", [])
        @broadcast_urls = results.map { |result| result["broadcast"] }
      elsif response.timed_out?
        puts "request timed out".red
      elsif response.code == 0
        puts response.return_message.red
      else
        puts "HTTP request failed: #{response.code.to_s}"
      end
    end
    @hydra.queue(request)
    @hydra.run
    puts @broadcast_urls.inspect.blue
  end

  def broadcast(broadcast_id)
    request = Typhoeus::Request.new(broadcast_url(broadcast_id), followlocation: true)
    request.on_complete do |response|
      if response.success?
        response.body
      elsif response.timed_out?
        puts "request timed out".red
      elsif response.code == 0
        puts response.return_message.red
      else
        puts "HTTP request failed: #{response.code.to_s}"
      end
    end
    @hydra.queue(request)
    @hydra.run
  end

  private

  def broadcast_url(broadcast_id)
    "http://resources.meerkatapp.co/broadcasts/#{broadcast_id}/summary"
  end
end
