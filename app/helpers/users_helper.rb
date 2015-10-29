module UsersHelper

  # @param [Array<Integer>] user_ids
  def user_mappings(user_ids)
    mappings = {}
    if user_ids.is_a? Array
      user_ids = user_ids.uniq
    else
      user_ids = user_ids.to_a
    end
    User.find(user_ids).each do |user|
      mappings[user.id] = user
    end

    mappings
  end

  # @param [User] user
  def simple_user_hash(user)
    {
        id: user.id,
        email: user.email,
        name: user.name,
        picture: "",
    }
  end
end
