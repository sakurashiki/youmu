![shindou](https://user-images.githubusercontent.com/10524945/32308975-fad39cfc-bfcb-11e7-9758-ab7b2036fa0e.jpg)

# What is youmu?

For effective twitter ads operation, we need to find the massive users. But twitter search does not have enough features.

This script enables you lookup twitter predation target users. Crawler loads user information from twitter api, filters and stores them to the database. After that processing, you can download users by CSV file.

# How to work?

This is very very normal Ruby on Rails apps. Do investigate yourself!

-> http://rubyonrails.org/

`/config/secrets.yml` need some parameters. For example:

```
development:
  secret_key_base: xxxxxxxxxxxxxxxxxxxxxxxxxx
  twitter_consumer_key: xxxxxxxxxxxxxxxxxxxxxxxxxx
  twitter_consumer_secret: xxxxxxxxxxxxxxxxxxxxxxxxxx
  database_username: youmu
  database_password: ""
  default_acccess_tokens: {access_token_1}:{access_token_secret_1},{access_token_2}:{access_token_secret_2}
  first_twitter_users: {twitter_screen_name_1},{twitter_screen_name_2},{twitter_screen_name_3}
test:
  secret_key_base: xxxxxxxxxxxxxx
production:
  secret_key_base: <%= ENV["SECRET_KEY_BASE"] %>
```

# License

It still not be under the open source license.
