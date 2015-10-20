`gem install rails --version=4.0.13`

DynamoDB schema:

category: id(hash), name(string)
forum: category(hash, category_id) name(range)
topic:
  forum(hash, forum_id) id(range) subject(string)
  local secondary index: user(int)
  local secondary index: last_post_at(int)
post:
  topic(hash, topic_id) updated_at(range)
  local secondary index: user(int)