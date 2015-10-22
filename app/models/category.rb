class Category < OceanDynamo::Table
  include ForumsHelper, Connection

  dynamo_schema(timestamps: [:created_at, :updated_at]) do
    attribute :category_name
  end

  validates :category_name, presence: true

  def self.new_from_hash(hash)
    category = self.new
    hash.each do |k, v|
      category.attributes[k] = v
    end

    category
  end

  def to_s
    name
  end

  def forums
    query(Forum.table_name, 'category = :id', ':id' => id).map do |f|
      simple_hash(f)
    end
  end

end
