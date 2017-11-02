# frozen_string_literal: true

class User < ApplicationRecord
  WAIT_TO_CRAWL_STATE = 0
  BAD_STATE = 1
  GOOD_STATE = 2

  class << self
    def store_from_twitter(twitter_user, data_status: 1)
      user = find_by(internal_id: twitter_user.id)
      if user
        update_from_twitter(user, twitter_user, data_status)
      else
        create_from_twitter(twitter_user, data_status)
      end
    end

    def create_from_twitter(twitter_user, data_status)
      create(
        internal_id: twitter_user.id,
        screen_name: twitter_user.screen_name,
        followers_count: twitter_user.followers_count,
        friends_count: twitter_user.friends_count,
        data_status: data_status
      )
    end

    def update_from_twitter(user, twitter_user, data_status)
      user.update(
        screen_name: twitter_user.screen_name,
        followers_count: twitter_user.followers_count,
        friends_count: twitter_user.friends_count,
        data_status: data_status
      )
    end
  end

  def connected_by(access_token_id)
    @access_token_id = access_token_id
    self
  end

  def client
    @client ||= Twitter::REST::Client.new do |config|
      app = Rails.application.secrets
      user = AccessToken.find(@access_token_id)
      config.consumer_key        = app.twitter_consumer_key
      config.consumer_secret     = app.twitter_consumer_secret
      config.access_token        = user.access_token
      config.access_token_secret = user.access_token_secret
    end
  end
end
