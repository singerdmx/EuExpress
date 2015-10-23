class Membership < OceanDynamo::Table

  dynamo_schema(table_name_prefix: Translation::TABLE_NAME_PREFIX, timestamps: [:created_at, :updated_at]) do
    attribute :group_id
    attribute :user_id, :integer
  end

end
