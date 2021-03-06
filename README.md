# Youmu - Powerful Twitter user crawler

![shindou](https://user-images.githubusercontent.com/10524945/32308975-fad39cfc-bfcb-11e7-9758-ab7b2036fa0e.jpg)

[星井★ヒサ](https://www.pixiv.net/member_illust.php?mode=medium&illust_id=50210057)

# What is youmu?

For effective twitter ads operation, we need to find the massive users to create audience list. But twitter search does not have enough features.

This script enables you lookup twitter predation target users. Crawler loads user information from twitter api, filters them with detail condition and stores them to the database. After that processing, you can download audience list by CSV file.

# Setup youmu.

This is very very normal Ruby on Rails apps. Do investigate yourself!

-> http://rubyonrails.org/

`/config/secrets.yml` need some parameters. For example:

```yml
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

# Execute crawler script.

Execute rails console command on bash.

```sh
LOOKUP_LANG=ja LOOKUP_STRING=soundcloud.com rails c
```

Just call an `User.crawl()` method. There are 2 argument to adjust crawling process.

- offset: start point of loading.
- limit: how many users to crawl.

```ruby
# example
User.crawl(limit: 100)
User.crawl(offset: 10, limit: 100)
```

# Get target user data.

Execute like this script on rails application route directory. The data would be outputted on stdout.

```sh
bundle exec rails runner 'User.where(data_status: [1,2]).order(followers_count: :desc).each { |u| p "#{u.followers_count},#{u.screen_name},https://twitter.com/#{u.screen_name}" }' 2> /dev/null | sed 's/"//g'
```

# License

It still not be under the open source license.
