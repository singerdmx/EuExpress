class Forum < OceanDynamo::Table

  dynamo_schema(timestamps: [:created_at, :updated_at]) do
    attribute :category
    attribute :name
    attribute :description
    attribute :views_count, :integer, default: 0
    attribute :position, :integer, default: 0
  end

  include Concerns::Viewable

  validates :category, :name, :description, :presence => true
  validates :position, numericality: { only_integer: true }

  alias_attribute :title, :name

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
    name
  end

end
