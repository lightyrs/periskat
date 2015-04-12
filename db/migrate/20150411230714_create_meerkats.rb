class CreateMeerkats < ActiveRecord::Migration
  def change
    create_table :meerkats do |t|
      t.string     :external_id, null: false
      t.string     :playlist_url
      t.string     :place_name
      t.string     :location_string
      t.float      :latitude
      t.float      :longitude
      t.text       :cover_images, array: true, default: []
      t.string     :cover
      t.integer    :likes_count
      t.integer    :comments_count
      t.integer    :restreams_count
      t.integer    :watchers_count
      t.datetime   :end_time
      t.text       :caption
      t.string     :status
      t.string     :twitter_tweet_id
      t.belongs_to :broadcaster
      t.timestamps null: false
    end

    add_index :meerkats, :broadcaster_id
    add_index :meerkats, :external_id, unique: true
  end
end
