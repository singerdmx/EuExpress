module ForumsHelper

  def simple_hash(forum_hash)
    h = {}
    %w(id name).each do |k|
      h[k] = forum_hash[k]
    end

    h
  end

  def topics_count(forum)
    if forem_admin_or_moderator?(forum)
      forum.topics.count
    else
      forum.topics.approved.count
    end
  end

  def posts_count(forum)
    if forem_admin_or_moderator?(forum)
      forum.posts.count
    else
      forum.posts.approved.count
    end
  end
end
