class ForumsController < ApplicationController
  load_and_authorize_resource class: 'Forum', only: :show
  helper TopicsHelper

  def index
    all_forums = Forum.all
    forums = attributes(all_forums, ['topics'])
    if stale?(etag: forums, last_modified: max_updated_at(all_forums))
      render json: forums
    else
      head :not_modified
    end
  rescue Exception => e
    Rails.logger.error "Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}"
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end

  def show
    authorize! :show, @forum
    register_view

    @topics = if forem_admin_or_moderator?(@forum)
                @forum.topics
              else
                @forum.topics.visible.approved_or_pending_review_for(forem_user)
              end

    @topics = @topics.by_pinned_or_most_recent_post

    # Kaminari allows to configure the method and param used
    @topics = @topics.send(pagination_method, params[pagination_param]).per(Forem.per_page)

    respond_to do |format|
      format.html
      format.atom { render :layout => false }
    end
  end

  private
  def register_view
    @forum.register_view_by(forem_user)
  end
end