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
    user = User.find(h['user_id'])
    h['user'] = user.name
    h['email'] = user.email
    h
  end

  def delete_group(group_id)
    delete(Group, {id: group_id})
    memberships = query(Membership, 'group_id = :g', ':g' => group_id)
    memberships.each do |membership|
      m = simple_membership_hash(membership)
      delete(Membership, {group_id: group_id, user_id: m['user_id']})
    end

    ModeratorGroup.all.select do |moderator_group|
      moderator_group.attributes['group'] == group_id
    end.each do |moderator_group|
      delete(ModeratorGroup, {forum: moderator_group.attributes['forum'], group: group_id})
    end
  end

  def group_url(group_id, group_name)
    "/admin/groups/#{group_id}?name=#{group_name}"
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
