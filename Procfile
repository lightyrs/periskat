web: bundle exec rails s thin
worker: bundle exec sidekiq -C ./config/sidekiq.yml
redis: leader --unless-port-in-use 6379 redis-server $REDIS_CONF_PATH
