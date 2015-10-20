class Category < OceanDynamo::Table
  include ForumsHelper, Connection

  dynamo_schema(timestamps: [:created_at, :updated_at]) do
    attribute :name
  end

  validates :name, presence: true

  def to_s
    name
  end

  def forums
    query(Forum.table_name, 'category = :id', ':id' => id).map do |f|
      simple_hash(f)
    end
  end

end
