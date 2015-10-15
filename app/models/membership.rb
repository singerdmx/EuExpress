class Membership < OceanDynamo::Table

  dynamo_schema(:guid,
                timestamps: [:created_at, :updated_at]) do
    attribute :member_id, :integer
  end

  belongs_to :group
end
