module Viewable
  # def view_for(user)
  #   views.find_by(user_id: user.id)
  # end

  # Track when users last viewed topics
  def register_view_by(user, viewable_type, viewable_id, viewable_key)
    return unless user

    update_expression = 'SET views_count = views_count + :val'
    expression_attribute_values = {':val' => 1}
    update(viewable_type, viewable_key,
           update_expression,
           expression_attribute_values)

    view_key = {user_id: user.id, id: "#{viewable_type}##{viewable_id}"}
    view = get('views', view_key)
    unless view
      View.create(
          user_id: user.id,
          id: "#{viewable_type}##{viewable_id}",
          viewable_id: viewable_id,
          viewable_type: viewable_type)
    else
      # Update the current_viewed_at if it is BEFORE 15 minutes ago.
      if view['current_viewed_at'].to_i < 15.minutes.ago.to_i
        update_expression += ', current_viewed_at = :current_viewed_at'
        update_expression += ', past_viewed_at = :past_viewed_at'
        expression_attribute_values[':past_viewed_at'] = view['current_viewed_at'].to_i
        expression_attribute_values[':current_viewed_at'] = Time.now.to_i
      end

      update('views', view_key,
             update_expression,
             expression_attribute_values)
    end

  end
end