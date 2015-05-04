class BroadcastPopulator

  def self.run
    instance = new
    instance.populate_from_stream!
  end

  def initialize
    @client = TwitterClient.new(:streaming)
  end

  def populate_from_stream!
    @client.filter_stream do |tweet|
      if tweet.is_a?(Twitter::Tweet) && tweet.text.match(/\|LIVE NOW\|/i).present?
        parse_and_persist_meerkat(tweet)
      elsif tweet.is_a?(Twitter::Tweet) &&
            tweet.text.match(/LIVE on #Periscope/i).present? &&
            tweet.text.match(/via/i).nil?
        parse_and_persist_periscope(tweet)
      end
    end
  end

  private

  def parse_and_persist_meerkat(tweet)
    meerkat_populator.parse_and_persist(tweet)
  end

  def parse_and_persist_periscope(tweet)
    periscope_populator.parse_and_persist(tweet)
  end

  def meerkat_populator
    @meerkat_populator ||= MeerkatPopulator.new
  end

  def periscope_populator
    @periscope_populator ||= PeriscopePopulator.new
  end
end
