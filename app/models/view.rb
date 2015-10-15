class View < OceanDynamo::Table

  dynamo_schema(:guid,
                timestamps: [:created_at, :updated_at]) do
    attribute :subscriber_id, :integer
    attribute :viewable_id, :integer
    attribute :views_count, :integer, default: 0
    attribute :viewable_type
    attribute :current_viewed_at, :datetime
    attribute :past_viewed_at, :datetime
  end

  before_create :set_viewed_at_to_now

  validates :viewable_id, :viewable_type, :presence => true

  def viewed_at
    updated_at
  end

  private
  def set_viewed_at_to_now
    self.current_viewed_at = Time.now
    self.past_viewed_at = current_viewed_at
  end
end
