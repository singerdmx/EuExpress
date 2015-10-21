module Autocomplete
  def forem_autocomplete(term)
    where("#{User.autocomplete_field} LIKE ?", "%#{term}%").
        limit(10).
        select("#{User.autocomplete_field}, id").
        order("#{User.autocomplete_field}")
  end

end