class Broadcaster < Ohm::Model
  include Ohm::Timestamps

  attribute  :twitter_user_id
  unique     :twitter_user_id
  index      :twitter_user_id

  attribute  :twitter_user_name
  attribute  :twitter_user_screen_name
  attribute  :twitter_user_avatar
  attribute  :twitter_user_profile_url
  attribute  :twitter_user_bio
  attribute  :twitter_user_following_count
  attribute  :twitter_user_followers_count
  attribute  :twitter_user_location
  attribute  :twitter_user_banner_url

  attribute  :meerkat_user_id
  attribute  :meerkat_user_profile_url

  attribute  :periscope_user_id
  attribute  :periscope_user_profile_url

  collection :meerkats,   :Meerkat
  collection :periscopes, :Periscope
end
