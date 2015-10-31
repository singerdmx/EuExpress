module TopicsHelper
  include Connection

  def get_topics(forum_id)
    query(Topic, 'forum = :f', {':f' => forum_id}, 'last_post_at_index')
  end

  def simple_topic_hash(topic_hash)
    h = {}
    %w(id subject posts forum).each do |k|
      h[k] = topic_hash[k] if topic_hash[k]
    end

    %w(user_id created_at last_post_at last_post_by views_count posts_count).each do |k|
      h[k] = topic_hash[k].to_i
    end
    h
  end

  def find_topic(forum_id = params[:forum_id], topic_id = params[:id])
    fail 'forum_id is not defined!' unless forum_id
    fail 'id is not defined!' unless topic_id
    @topic = get(Topic, {forum: forum_id, id: topic_id})
    fail "Unable to find topic given forum #{forum_id} topic_id #{topic_id}" unless @topic
  end

  def delete_topic(forum_id, topic_id)
    delete(Topic, {forum: forum_id, id: topic_id})
    #TODO delete associated user favorites and posts, or have a to_delete table to have a cron job periodically scan user favorites and posts
  end

  def link_to_latest_post(topic)
    post = relevant_posts(topic).last
    return '' unless post
    text = "#{time_ago_in_words(post.created_at)} #{t("ago_by")} #{post.user.forem_name}"
    link_to text, forum_topic_path(post.topic.forum, post.topic, :anchor => "post-#{post.id}", pagination_param => topic.last_page)
  end

  alias_method :get_link_to_latest_post, :link_to_latest_post

  def new_since_last_view_text(topic)
    if forem_user
      topic_view = topic.view_for(forem_user)
      forum_view = topic.forum.view_for(forem_user)

      if forum_view
        if topic_view.nil? && topic.created_at > forum_view.past_viewed_at
          content_tag :super, "New"
        end
      end
    end
  end

  def relevant_posts(topic)
    posts = topic.posts.by_created_at
    if forem_admin_or_moderator?(topic.forum)
      posts
    elsif topic.user == forem_user
      posts.visible.approved_or_pending_review_for(topic.user)
    else
      posts.approved
    end
  end

  alias_method :get_relevant_posts, :relevant_posts

  def post_time_tag(post)
    content_tag("time", datetime: post.created_at.to_s(:db)) do
      "#{time_ago_in_words(post.created_at)} #{t(:ago)}"
    end
  end

end
