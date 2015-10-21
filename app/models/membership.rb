class Membership < OceanDynamo::Table

  dynamo_schema(timestamps: [:created_at, :updated_at]) do
    attribute :group
    attribute :user_id, :integer
  end

end
