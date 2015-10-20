class CategoriesController < ApplicationController
  load_and_authorize_resource class: 'Category'

  ATTRIBUTES_EXCLUSION = ApplicationHelper::ATTRIBUTES_EXCLUSION << 'id'

  def index
    @categories = Category.all
    respond_to do |format|
      format.html
      format.json do
        render json: attributes(@categories, ['forums'], ATTRIBUTES_EXCLUSION)
      end
    end
  end
end
