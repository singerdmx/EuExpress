class FavoriteForums < OceanDynamo::Table

  dynamo_schema(table_name_prefix: Translation::TABLE_NAME_PREFIX, timestamps: [:created_at, :updated_at]) do
    attribute :user_id, :integer
    attribute :category
    attribute :forum
  end

  validates :user_id, :category, :forum, presence: true

end
