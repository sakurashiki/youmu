# frozen_string_literal: true

# rubocop:disable Metrics/AbcSize, Metrics/MethodLength

class User < ApplicationRecord
  NOT_TARGET_USER       = 0
  CRAWLABLE_TARGET_USER = 1
  CRAWLED_TARGET_USER   = 2

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
        data_status: data_status,
        lang: twitter_user.lang
      )
    end

    def update_from_twitter(user, twitter_user, data_status)
      user.update(
        screen_name: twitter_user.screen_name,
        followers_count: twitter_user.followers_count,
        friends_count: twitter_user.friends_count,
        data_status: data_status,
        lang: twitter_user.lang
      )
    end

    def string_contains?(twitter_user)
      return false unless twitter_user.lang == ENV['LOOKUP_LANG']
      return true if twitter_user.name.include?(ENV['LOOKUP_STRING'])
      return true if twitter_user.description.include?(ENV['LOOKUP_STRING'])
      entities = twitter_user.attrs[:entities]
      urls = entities[:url]&.[](:urls)
      urls&.each do |url|
        return true if url[:expanded_url]&.include?(ENV['LOOKUP_STRING'])
      end
      urls = entities[:description]&.[](:urls)
      urls&.each do |url|
        return true if url[:expanded_url]&.include?(ENV['LOOKUP_STRING'])
      end
      false
    end

    def crawl_friend(internal_id)
      token_ids = []
      access_tokens = AccessToken.all
      500.times { access_tokens.each { |at| token_ids.push(at.id) } }
      friend_ids = new.connected_by(AccessToken.all.sample.id)
                      .client.friend_ids(internal_id).take(5000)
      return false if token_ids.count < friend_ids.count
      friend_ids.each do |friend_id|
        user = find_by(internal_id: friend_id)
        next unless user.nil?
        begin
          twitter_user = new.connected_by(token_ids.pop).client.user(friend_id)
        rescue Twitter::Error => e
          p e.message
          next
        end
        if string_contains?(twitter_user)
          create_from_twitter(twitter_user, CRAWLABLE_TARGET_USER)
        else
          create_from_twitter(twitter_user, NOT_TARGET_USER)
        end
      end
      User.where(internal_id: internal_id).update(data_status: CRAWLED_TARGET_USER)
      true
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
