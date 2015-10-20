class CategoriesController < ApplicationController
  load_and_authorize_resource class: 'Category'

  def index
    all_categories = Category.all
    categories = attributes(all_categories, ['forums'])
    if stale?(etag: categories, last_modified: max_updated_at(all_categories))
      render json: categories
    else
      head :not_modified
    end
  rescue Exception => e
    Rails.logger.error "Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}"
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end
end
