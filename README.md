`gem install rails --version=4.0.13`

DynamoDB schema:

category: name(hash)
forum: category(hash) name(range)
topic:
  forum(hash) id(range) subject(string)
  local secondary index: user(int)
  local secondary index: last_post_at(int)
post:
  topic(hash) updated_at(range)
  local secondary index: user(int)