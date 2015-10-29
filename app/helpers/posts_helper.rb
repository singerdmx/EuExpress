module PostsHelper
  include Connection

  def get_posts(topic_id)
    query(Post, 'topic = :t', ':t' => topic_id)
  end

  def simple_hash(post_hash)
    h = {}
    %w(id text reply_to_post updated_at).each do |k|
      h[k] = post_hash[k]
    end

    %w(updated_at user_id created_at).each do |k|
      h[k] = post_hash[k].to_i
    end

    h
  end

end
