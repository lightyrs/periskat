class CreatePeriscopes < ActiveRecord::Migration
  def change
    create_table :periscopes do |t|
      t.string     :secure_playlist_url
      t.string     :playlist_url
      t.string     :url
      t.string     :channel
      t.string     :twitter_tweet_id
      t.string     :twitter_tweet_url
      t.string     :twitter_tweet_source
      t.text       :twitter_tweet_text
      t.timestamps null: false
    end

    add_index :periscopes, :url, unique: true
  end
end
