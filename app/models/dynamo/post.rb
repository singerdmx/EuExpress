require_relative '../../../lib/state_workflow'

class Post < OceanDynamo::Table
  include Workflow
  include StateWorkflow
  include Connection

  dynamo_schema(table_name_prefix: Translation::TABLE_NAME_PREFIX, timestamps: [:created_at, :updated_at]) do
    attribute :user_id, :integer
    attribute :category
    attribute :forum
    attribute :topic
    attribute :text
    attribute :state, default: 'approved'
    attribute :notified, :boolean, default: false
    attribute :reply_to_post
  end

  # Used in the moderation tools partial
  attr_accessor :moderation_option

  validates :text, presence: true

  after_create :after_create
  after_save :after_save #TODO verify it's working
  # after_create :subscribe_replier, :if => :user_auto_subscribe?
  # after_create :skip_pending_review

  class << self
    def approved
      where(:state => "approved")
    end

    def approved_or_pending_review_for(user)
      if user
        state_column = "#{Post.table_name}.state"
        where("#{state_column} = 'approved' OR
            (#{state_column} = 'pending_review' AND #{Post.table_name}.user_id = :user_id)",
              user_id: user.id)
      else
        approved
      end
    end

    def by_created_at
      order :created_at
    end

    def pending_review
      where :state => 'pending_review'
    end

    def spam
      where :state => 'spam'
    end

    def moderate!(posts)
      posts.each do |post_id, moderation|
        # We use find_by_id here just in case a post has been deleted.
        post = Post.find_by_id(post_id)
        post.send("#{moderation[:moderation_option]}!") if post
      end
    end
  end

  def user_auto_subscribe?
    user && user.respond_to?(:forem_auto_subscribe) && user.forem_auto_subscribe?
  end

  def owner_or_admin?(other_user)
    user == other_user || other_user.forem_admin?
  end

  protected

  def subscribe_replier
    if topic && user
      topic.subscribe_user(user.id)
    end
  end

  # Called when a post is approved.
  def approve
    approve_user
    return if notified?
    email_topic_subscribers
  end

  def email_topic_subscribers
    topic.subscriptions.includes(:subscriber).find_each do |subscription|
      subscription.send_notification(id) if subscription.subscriber != user
    end
    update_column(:notified, true)
  end

  def after_create
    increment_posts_count
    set_forum_last_post
    set_topic_last_post
  end

  def after_save
    set_forum_last_post
    set_topic_last_post
  end

  def skip_pending_review
    approve! unless user && user.forem_moderate_posts?
  end

  def approve_user
    user.update_column(:forem_state, "approved") if user && user.forem_state != "approved"
  end

  def spam
    user.update_column(:forem_state, "spam") if user
  end

  private

  def increment_posts_count
    update_expression = 'SET posts_count = posts_count + :val'
    expression_attribute_values = {':val' => 1}
    update(Forum, {category: category, id: forum},
           update_expression,
           expression_attribute_values)
  end

  def set_forum_last_post
    update_expression = 'SET last_post_id = :last_post_id, last_post_by = :last_post_by, last_topic_id = :last_topic_id'
    expression_attribute_values = {':last_post_id' => id, ':last_post_by' => user_id, ':last_topic_id' => topic}
    update(Forum, {category: category, id: forum},
           update_expression,
           expression_attribute_values)
  end

  def set_topic_last_post
    update_expression = 'SET last_post_at = :last_post_at, last_post_by = :last_post_by'
    expression_attribute_values = {':last_post_at' => updated_at.to_i, ':last_post_by' => user_id}
    update(Topic, {forum: forum, id: topic},
           update_expression,
           expression_attribute_values)
  end

end
