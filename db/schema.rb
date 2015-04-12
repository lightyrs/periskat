# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150411231117) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "broadcasters", force: :cascade do |t|
    t.string   "external_id",          null: false
    t.string   "username"
    t.string   "display_name"
    t.string   "avatar_url"
    t.string   "avatar_thumbnail_url"
    t.string   "profile_url"
    t.string   "twitter_user_id"
    t.string   "privacy"
    t.text     "bio"
    t.integer  "streams_count"
    t.integer  "following_count"
    t.integer  "followers_count"
    t.integer  "score"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "broadcasters", ["external_id"], name: "index_broadcasters_on_external_id", unique: true, using: :btree

  create_table "meerkats", force: :cascade do |t|
    t.string   "external_id",                   null: false
    t.string   "playlist_url"
    t.string   "place_name"
    t.string   "location_string"
    t.float    "latitude"
    t.float    "longitude"
    t.text     "cover_images",     default: [],              array: true
    t.string   "cover"
    t.integer  "likes_count"
    t.integer  "comments_count"
    t.integer  "restreams_count"
    t.integer  "watchers_count"
    t.datetime "end_time"
    t.text     "caption"
    t.string   "status"
    t.string   "twitter_tweet_id"
    t.integer  "broadcaster_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "meerkats", ["broadcaster_id"], name: "index_meerkats_on_broadcaster_id", using: :btree
  add_index "meerkats", ["external_id"], name: "index_meerkats_on_external_id", unique: true, using: :btree

end
