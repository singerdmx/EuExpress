class CategoriesController < ApplicationController
  helper ForumsHelper
  load_and_authorize_resource class: 'Forem::Category'

  def index
    @categories = Forem::Category.by_position
    respond_to do |format|
      format.html
      format.json { render json: @categories }
    end
  end
end
