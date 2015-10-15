class Group < OceanDynamo::Table

  dynamo_schema(:guid,
                timestamps: [:created_at, :updated_at]) do
    attribute :name
    attribute :views_count, :integer, default: 0
    attribute :position, :integer, default: 0
  end

  validates :name, :presence => true

  has_many :memberships

  def to_s
    name
  end
end
