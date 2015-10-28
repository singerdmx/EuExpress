class Category < OceanDynamo::Table
  include ForumsHelper

  dynamo_schema(table_name_prefix: Translation::TABLE_NAME_PREFIX, timestamps: [:created_at, :updated_at]) do
    attribute :category_name
  end

  validates :category_name, presence: true

  def to_s
    category_name
  end

  def forums
    query(Forum, 'category = :id', ':id' => id).map do |f|
      simple_forum_hash(f)
    end
  end

end
