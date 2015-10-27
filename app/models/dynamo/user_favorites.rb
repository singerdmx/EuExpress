class UserFavorites < OceanDynamo::Table

  dynamo_schema(table_name_prefix: Translation::TABLE_NAME_PREFIX, timestamps: [:created_at, :updated_at]) do
    attribute :user_id, :integer
    attribute :type
    attribute :favorite
  end

  validates :user_id, :type, :favorite, presence: true

end
