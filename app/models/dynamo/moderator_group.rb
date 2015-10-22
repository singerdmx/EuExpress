class ModeratorGroup  < OceanDynamo::Table

  dynamo_schema(timestamps: [:created_at, :updated_at]) do
    attribute :forum
    attribute :group
  end

end

