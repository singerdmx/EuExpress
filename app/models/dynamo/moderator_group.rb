class ModeratorGroup  < OceanDynamo::Table

  dynamo_schema(table_name_prefix: Translation::TABLE_NAME_PREFIX, timestamps: [:created_at, :updated_at]) do
    attribute :forum
    attribute :group
  end

end

