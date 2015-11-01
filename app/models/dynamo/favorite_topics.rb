class FavoriteTopics < OceanDynamo::Table

  dynamo_schema(table_name_prefix: Translation::TABLE_NAME_PREFIX, timestamps: [:created_at, :updated_at]) do
    attribute :user_id, :integer
    attribute :forum
    attribute :topic
  end

  validates :user_id, :forum, :topic, presence: true

end
