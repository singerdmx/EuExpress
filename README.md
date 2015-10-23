`gem install rails --version=4.0.13`

DynamoDB schema:

category: id(hash)

forum: category(hash, category_id), id(range), forum_name(string)

  local secondary index: forum_name(string)

topic:

  forum(hash, forum_id) id(range) subject(string)
  
  local secondary index: user(int)
  
  local secondary index: last_post_at(int)
  
post:

  topic(hash, topic_id) id(range) updated_at(int)
  
  local secondary index: user(int)
  
  local secondary index: updated_at(int)
  
view:

  user(hash), id(range, string, "viewable_type#viewable_id")
  
  viewable_id(int, topic_id or forum_id) viewable_type(string, i.e. table_name, e.g. 'topics' or 'forums')
  
group: id(hash), name(string)

membership: group_id(hash), user_id(range)

moderator_group: forum(hash, forum_id), group(range, group_id) 

subscription: topic(hash, topic_id), user_id(range)