class CreateBroadcasters < ActiveRecord::Migration
  def change
    create_table :broadcasters do |t|
      t.string     :twitter_user_id,         null: false
      t.string     :twitter_user_name
      t.string     :twitter_user_screen_name
      t.string     :twitter_user_avatar
      t.string     :twitter_user_profile_url
      t.string     :twitter_user_banner_url
      t.integer    :twitter_user_followers_count
      t.integer    :twitter_user_following_count
      t.string     :twitter_user_location
      t.text       :twitter_user_bio
      t.timestamps                           null: false
    end

    add_index :broadcasters, :twitter_user_id, unique: true
  end
end
