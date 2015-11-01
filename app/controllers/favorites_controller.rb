class FavoritesController < ApplicationController
  include Connection

  protect_from_forgery except: [:create, :destroy]

  def index
    if current_user.nil?
      render json: {}
      return
    end

    case params[:type]
      when 'forum'
        all_favorites = query(FavoriteForums, 'user_id = :u', ':u' => current_user.id)
      when 'topic'
        all_favorites = query(FavoriteTopics, 'user_id = :u', ':u' => current_user.id)
      else
        fail "Invalid parameter 'type': #{params[:type]}"
    end

    favorites = all_favorites.map do |favorite|
      favorite[params[:type]]
    end
    if stale?(etag: favorites, last_modified: max_updated_at(all_favorites))
      render json: favorites
    else
      head :not_modified
    end
  rescue Exception => e
    Rails.logger.error "Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}"
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end

  def create
    if current_user.nil?
      render json: {success: true}
      return
    end
    case params[:type]
      when 'forum'
        FavoriteForums.create(user_id: current_user.id, category: params[:category], forum: params[:forum])
      when 'topic'
        FavoriteTopics.create(user_id: current_user.id, forum: params[:forum], topic: params[:topic])
      else
        fail "Invalid parameter 'type': #{params[:type]}"
    end
    render json: {success: true}
  rescue Exception => e
    Rails.logger.error "Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}"
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end

  def destroy
    if current_user.nil?
      render json: {success: true}
      return
    end
    case params[:type]
      when 'forum'
        delete(FavoriteForums, {user_id: current_user.id, forum: params[:id]})
      when 'topic'
        delete(FavoriteTopics, {user_id: current_user.id, topic: params[:id]})
      else
        fail "Invalid parameter 'type': #{params[:type]}"
    end
    render json: {success: true}
  rescue Exception => e
    Rails.logger.error "Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}"
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end

end