# frozen_string_literal: true

screen_names  = Rails.application.secrets.first_twitter_users.split(',')
access_tokens = Rails.application.secrets.default_acccess_tokens

p 'Start: AccessToken'
access_tokens.split(',').each do |line|
  access_token        = line.split(':')[0]
  access_token_secret = line.split(':')[1]
  if AccessToken.find_by(access_token: access_token)
    p "Skip: #{access_token} - #{access_token_secret}"
    next
  end
  p "Create: #{access_token} - #{access_token_secret}"
  AccessToken.create(
    access_token:        access_token,
    access_token_secret: access_token_secret
  )
end

p 'Start: User'
client = User.new.connected_by(AccessToken.first.id).client
screen_names.each do |screen_name|
  twitter = client.user(screen_name)
  p "Store: #{twitter.screen_name} - #{twitter.name}"
  User.store_from_twitter(twitter, data_status: User::CRAWLABLE_TARGET_USER)
end
