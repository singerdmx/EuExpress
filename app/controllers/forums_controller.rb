class ForumsController < ApplicationController
  before_filter :find_forum, only: [:show]
  helper TopicsHelper
  include ForumsHelper

  def index
    all_forums = Forum.all
    forums = attributes(all_forums, ['topics', 'moderators'])
    respond_to do |format|
      format.html do
        @favorites = []
        if current_user
          @favorites = query(UserFavorites, 'user_id = :u', ':u' => current_user.id).group_by { |f| f['type'] }
          @favorites['forum'] = @favorites['forum'].map do |favorite|
            h = {}
            h['id'] = favorite['favorite']
            forum = forums.find { |f| f['id'] == h['id']}
            h['name'] = forum['forum_name'] if forum
            h
          end
        end
      end
      format.json do
        if stale?(etag: forums, last_modified: max_updated_at(all_forums))
          render json: forums
        else
          head :not_modified
        end
      end
    end
  rescue Exception => e
    Rails.logger.error "Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}"
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end

  def show
    register_view_by(current_user, Forum, @forum['id'],
                     {category: params[:category_id], id: params[:id]})
    render json: simple_hash(@forum)
  end
end