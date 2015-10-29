class Group < OceanDynamo::Table
  include GroupHelper, UsersHelper

  dynamo_schema(table_name_prefix: Translation::TABLE_NAME_PREFIX, timestamps: [:created_at, :updated_at]) do
    attribute :name
  end

  validates :name, presence: true

  def to_s
    name
  end

  def members
    users = query(Membership, 'group_id = :val', ':val' => id).map do |m|
      simple_membership_hash(m)
    end

    mappings = user_mappings(users.map { |u| u['user_id'] })
    users.each do |u|
      user = mappings[u['user_id']]
      u['user'] = user.name
      u['email'] = user.email
    end

    users
  end
end
