module PostsHelper
  include Connection

  def get_posts(topic_id)
    query(Post, 'topic = :t', {':t' => topic_id}, 'updated_at_index')
  end

  def simple_post_hash(post_hash)
    h = {}
    %w(id text topic).each do |k|
      h[k] = post_hash[k]
    end

    %w(updated_at user_id created_at reply_to_post).each do |k|
      h[k] = post_hash[k].to_i if post_hash[k]
    end

    h
  end

end
