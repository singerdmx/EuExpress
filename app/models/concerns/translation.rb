require 'active_support/concern'

module Translation

  def self.new_from_hash(hash)
    obj = self.new
    hash.each do |k, v|
      obj.attributes[k] = v
    end

    obj
  end

end