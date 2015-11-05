module PostsHelper
  include Connection

  def get_posts(topic_id)
    query(Post, 'topic = :t', {':t' => topic_id}, 'updated_at_index')
  end

  def simple_post_hash(post_hash)
    h = {}
    %w(id body_text topic forum category).each do |k|
      h[k] = post_hash[k]
    end

    %w(updated_at user_id created_at reply_to_post).each do |k|
      h[k] = post_hash[k].to_i if post_hash[k]
    end

    h
  end

  def delete_post(topic_id, post_id)
    delete_item(Post, {topic: topic_id, id: post_id})
  end

  def update_post(topic_id, post_id, text)
    update_expression = 'SET body_text = :val, updated_at = :updated_at'
    expression_attribute_values = {':val' => text, ':updated_at' => Time.now.to_i}
    update_item(Post, {topic: topic_id, id: post_id},
                update_expression,
                expression_attribute_values)
  end

end
