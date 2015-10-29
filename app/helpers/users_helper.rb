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
        picture: avatar_url(user.email, size: 60),
    }
  end

  def avatar_url(email, options = {})
    require 'digest/md5' unless defined?(Digest::MD5)
    md5 = Digest::MD5.hexdigest(email.to_s.strip.downcase)

    options[:s] = options.delete(:size) || 60
    options[:d] = options.delete(:default) || default_gravatar
    options.delete(:d) unless options[:d]
    "#{request.ssl? ? 'https://secure' : 'http://www'}.gravatar.com/avatar/#{md5}?#{options.to_param}"
  end

  def default_gravatar
    image = Forem.default_gravatar_image

    case
      when image && URI(image).absolute?
        image
      when image
        request.protocol +
            request.host_with_port +
            path_to_image(image)
      else
        Forem.default_gravatar
    end
  end
end
