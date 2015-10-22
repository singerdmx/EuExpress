class Membership < OceanDynamo::Table

  dynamo_schema(timestamps: [:created_at, :updated_at]) do
    attribute :group_id
    attribute :user_id, :integer
  end

end
