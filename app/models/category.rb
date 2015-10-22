class Category < OceanDynamo::Table
  include ForumsHelper, Connection, Translation

  dynamo_schema(timestamps: [:created_at, :updated_at]) do
    attribute :category_name
  end

  validates :category_name, presence: true

  def to_s
    name
  end

  def forums
    query(Forum.table_name, 'category = :id', ':id' => id).map do |f|
      simple_hash(f)
    end
  end

end
