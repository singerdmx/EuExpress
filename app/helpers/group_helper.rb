module GroupHelper

  def simple_group_hash(group_hash)
    h = {}
    %w(id name).each do |k|
      h[k] = group_hash[k] if group_hash[k]
    end

    h
  end
end
