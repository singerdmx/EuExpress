module GroupHelper
  include Connection

  def simple_group_hash(group_hash)
    h = {}
    %w(id name).each do |k|
      h[k] = group_hash[k] if group_hash[k]
    end

    h
  end

  def simple_membership_hash(membership_hash)
    h = {}
    h['group_id'] = membership_hash['group_id']
    h['user_id'] = membership_hash['user_id'].to_i
    h['user'] = User.find(h['user_id']).name
    h
  end

  def batch_get_groups(group_ids)
    keys = group_ids.map do |group_id|
      {
          id: group_id,
      }
    end

    response = batch_get(
        {
            Group.get_table_name => {
                keys: keys,
                consistent_read: false,
            }
        })

    response[Group.get_table_name].map { |g| simple_group_hash(g) }
  end
end
