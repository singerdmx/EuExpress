class Category < OceanDynamo::Table

  dynamo_schema(timestamps: [:created_at, :updated_at]) do
    attribute :name
    attribute :position, :integer, default: 0
  end

  validates :name, :presence => true
  validates :position, numericality: {only_integer: true}

  def to_s
    name
  end

end
