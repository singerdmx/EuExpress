class View < OceanDynamo::Table

  dynamo_schema(timestamps: [:created_at, :updated_at]) do
    attribute :user_id, :integer
    attribute :viewable_id
    attribute :views_count, :integer, default: 1
    attribute :viewable_type
    attribute :current_viewed_at, :integer
    attribute :past_viewed_at, :integer
  end

  before_create :set_viewed_at_to_now

  validates :viewable_id, :viewable_type, presence: true

  def viewed_at
    updated_at
  end

  private

  def set_viewed_at_to_now
    self.current_viewed_at = Time.now.to_i
    self.past_viewed_at = current_viewed_at
  end
end
