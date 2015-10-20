class ForumsController < ApplicationController
  before_filter :find_forum, only: [:show]
  helper TopicsHelper
  include ForumsHelper

  def index
    respond_to do |format|
      format.html
      format.json do
        all_forums = Forum.all
        forums = attributes(all_forums, ['topics'])
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
    # register_view
    render json: simple_hash(@forum)
  end

  private
  def register_view
    @forum.register_view_by(forem_user)
  end
end