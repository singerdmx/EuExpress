class Admin::UsersController < ApplicationController
  def autocomplete
    users = User.forem_autocomplete(params[:term])
    users = users.map do |u|
      {id: u.id, identifier: u.send(Forem.autocomplete_field)}
    end
    render :json => users
  end
end
