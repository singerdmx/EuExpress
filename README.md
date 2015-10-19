`gem install rails --version=4.0.13`

DynamoDB schema:

category: name(hash)
forum: category(hash) name(range)
topic:
  forum_name#uuid(hash) last_post_at(range) subject(string)
  local secondary index: user(int)
post:
  topic_uuid(hash) updated_at(range)
  local secondary index: user(int)