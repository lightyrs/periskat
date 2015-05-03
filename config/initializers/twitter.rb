raw_config = File.read("#{Rails.root}/config/twitter.yml")
yaml       = YAML.load(raw_config)[Rails.env].symbolize_keys

TWITTER_CONSUMER_KEY        = yaml[:twitter_consumer_key]
TWITTER_CONSUMER_SECRET     = yaml[:twitter_consumer_secret]
TWITTER_ACCESS_TOKEN        = yaml[:twitter_access_token]
TWITTER_ACCESS_TOKEN_SECRET = yaml[:twitter_access_token_secret]
