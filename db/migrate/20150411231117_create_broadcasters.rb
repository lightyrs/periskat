class CreateBroadcasters < ActiveRecord::Migration
  def change
    create_table :broadcasters do |t|
      t.string  :external_id, null: false
      t.string  :username
      t.string  :display_name
      t.string  :avatar_url
      t.string  :avatar_thumbnail_url
      t.string  :profile_url
      t.string  :twitter_user_id
      t.string  :privacy
      t.text    :bio
      t.integer :streams_count
      t.integer :following_count
      t.integer :followers_count
      t.integer :score
      t.timestamps null: false
    end

    add_index :broadcasters, :external_id, unique: true
  end
end
