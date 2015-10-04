class ForumsController < ApplicationController
  load_and_authorize_resource class: 'Forem::Forum', only: :show
  helper Forem::TopicsHelper

  def index
    @categories = Forem::Category.all
    respond_to do |format|
      format.html
      format.json { render json: Forem::Forum.all }
    end
  end
end