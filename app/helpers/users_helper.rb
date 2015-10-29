module UsersHelper

  # @param [Array<Integer>] user_ids
  def user_mappings(user_ids)
    mappings = {}
    User.find(user_ids.uniq).each do |user|
      mappings[user.id] = user
    end

    mappings
  end
end
