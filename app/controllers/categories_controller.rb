class CategoriesController < ApplicationController

  def index
    @categories = Forem::Category.by_position
    respond_to do |format|
      format.html
      format.json { render json: @categories }
    end
  end
end
