# frozen_string_literal: true

class User < ApplicationRecord
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
