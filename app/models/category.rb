class Category < OceanDynamo::Table
  include Connection

  dynamo_schema(timestamps: [:created_at, :updated_at]) do
    attribute :name
  end

  validates :name, presence: true

  def to_s
    name
  end

  def forums
    query(Forum.table_name, 'category = :n', ':n' => name).map do |f|
      f['name']
    end
  end

end
