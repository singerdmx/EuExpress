class ForumsController < ApplicationController
  before_filter :find_forum, only: [:show]
  helper TopicsHelper
  include ForumsHelper

  def index
    respond_to do |format|
      format.html
      format.json do
        all_forums = Forum.all
        forums = attributes(all_forums, ['topics', 'moderators'])
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
    render json: simple_forum_hash(@forum)
  end
end