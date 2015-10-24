class Group < OceanDynamo::Table
  include GroupHelper

  dynamo_schema(table_name_prefix: Translation::TABLE_NAME_PREFIX, timestamps: [:created_at, :updated_at]) do
    attribute :name
  end

  validates :name, presence: true

  def to_s
    name
  end

  def members
    query(Membership, 'group_id = :val', ':val' => id).map do |m|
      simple_membership_hash(m)
    end
  end
end
