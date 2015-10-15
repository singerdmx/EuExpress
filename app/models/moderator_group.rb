class ModeratorGroup  < OceanDynamo::Table

  dynamo_schema(:guid,
                timestamps: [:created_at, :updated_at]) do
    attribute :groud_id, :integer
  end

  belongs_to :forum, composite_key: true
end

