class CategoriesController < ApplicationController
  load_and_authorize_resource class: 'Category'

  ATTRIBUTES_EXCLUSION = ApplicationHelper::ATTRIBUTES_EXCLUSION.dup << 'id'

  def index
    categories = Category.all
    if stale?(etag: categories, last_modified: max_updated_at(categories))
      render json: attributes(categories, ['forums'], ATTRIBUTES_EXCLUSION)
    else
      head :not_modified
    end
  rescue Exception => e
    Rails.logger.error "Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}"
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end
end
