class Group < OceanDynamo::Table

  dynamo_schema(timestamps: [:created_at, :updated_at]) do
    attribute :name
  end

  validates :name, presence: true

  def to_s
    name
  end
end
