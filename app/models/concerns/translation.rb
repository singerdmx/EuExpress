module Translation

  def new_from_hash(hash)
    obj = self.new
    hash.each do |k, v|
      obj.attributes[k] = v
    end

    obj
  end

end