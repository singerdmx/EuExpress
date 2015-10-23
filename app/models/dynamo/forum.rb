class Forum < OceanDynamo::Table
  include TopicsHelper, GroupHelper

  dynamo_schema(table_name_prefix: Translation::TABLE_NAME_PREFIX, timestamps: [:created_at, :updated_at]) do
    attribute :category
    attribute :forum_name
    attribute :description
    attribute :views_count, :integer, default: 0
  end

  validates :category, :forum_name, :description, presence: true

  alias_attribute :title, :forum_name

  def topics
    query(Topic, 'forum = :id', ':id' => id).map do |t|
      simple_topic_hash(t)
    end.sort do |a, b|
      b['last_post_at'] <=> a['last_post_at']
    end
  end

  def moderators
    moderator_group_ids = query(ModeratorGroup, 'forum = :id', ':id' => id).map do |moderator_group|
      moderator_group['group']
    end
    
    return [] if moderator_group_ids.empty?

    batch_get_groups(moderator_group_ids)
    # moderators = Set.new
    # moderator_group_ids.each do |moderator_group_id|
    #   query(Membership, 'group_id = :val', ':val' => moderator_group_id).each do |membership|
    #     moderators.add membership['user_id'].to_i
    #   end
    # end
    # moderators
  end

  def last_post_for(forem_user)
    if forem_user && (forem_user.forem_admin? || moderator?(forem_user))
      posts.last
    else
      last_visible_post(forem_user)
    end
  end

  def last_visible_post(forem_user)
    posts.approved_or_pending_review_for(forem_user).last
  end

  def moderator?(user)
    user && (user.forem_group_ids & moderator_ids).any?
  end

  def to_s
    forum_name
  end

end
