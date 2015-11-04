require 'set'

class PostsController < ApplicationController
  include PostsHelper, UsersHelper

  before_filter :authenticate_forem_user, except: [:index, :show]
  # before_filter :find_topic
  # before_filter :reject_locked_topic!, only: [:create]
  protect_from_forgery except: [:create, :destroy, :update]

  def index
    fail 'params topic_id is undefined!' unless params[:topic_id]
    all_posts = get_posts(params[:topic_id])
    posts = all_posts.map do |p|
      simple_post_hash(p)
    end

    user_ids = Set.new
    posts.each do |post|
      user_ids.add(post['user_id'])
    end
    mappings = user_mappings(user_ids)
    posts.each do |post|
      post['user'] = simple_user_hash(mappings[post['user_id']])
      post.delete('user_id')
    end

    if stale?(etag: posts, last_modified: max_updated_at(all_posts))
      render json: posts
    else
      head :not_modified
    end
  rescue Exception => e
    Rails.logger.error "Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}"
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end

  def create
    Post.create(category: params['category'],
                forum: params['forum_id'],
                topic: params['topic_id'],
                text: params['text'],
                user_id: current_user.id)
    render json: {success: true}
  rescue Exception => e
    Rails.logger.error "Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}"
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end

  def update
    authorize_edit_post_for_forum!
    find_post
    if @post.owner_or_admin?(forem_user) && @post.update_attributes(post_params)
      update_successful
    else
      update_failed
    end
  end

  def destroy
    authorize_destroy_post_for_forum!
    find_post
    unless @post.owner_or_admin? forem_user
      flash[:alert] = t("forem.post.cannot_delete")
      redirect_to [@topic.forum, @topic] and return
    end
    @post.destroy
    destroy_successful
  end

  private

  def post_params
    params.require(:post).permit(:text, :reply_to_id)
  end

  def authorize_reply_for_topic!
    authorize! :reply, @topic
  end

  def authorize_edit_post_for_forum!
    authorize! :edit_post, @topic.forum
  end

  def authorize_destroy_post_for_forum!
    authorize! :destroy_post, @topic.forum
  end

  def create_successful
    flash[:notice] = t("forem.post.created")
    redirect_to forum_topic_url(@topic.forum, @topic, pagination_param => @topic.last_page)
  end

  def create_failed
    params[:reply_to_id] = params[:post][:reply_to_id]
    flash.now.alert = t("forem.post.not_created")
    render :action => "new"
  end

  def destroy_successful
    if @post.topic.posts.count == 0
      @post.topic.destroy
      flash[:notice] = t("forem.post.deleted_with_topic")
      redirect_to [@topic.forum]
    else
      flash[:notice] = t("forem.post.deleted")
      redirect_to [@topic.forum, @topic]
    end
  end

  def update_successful
    redirect_to [@topic.forum, @topic], :notice => t('edited', :scope => 'forem.post')
  end

  def update_failed
    flash.now.alert = t("forem.post.not_edited")
    render :action => "edit"
  end

  def find_topic
    @topic = Forem::Topic.friendly.find params[:topic_id]
  end

  def find_post
    @post = @topic.posts.find params[:id]
  end

  def block_spammers
    if forem_user.forem_spammer?
      flash[:alert] = t('forem.general.flagged_for_spam') + ' ' +
          t('forem.general.cannot_create_post')
      redirect_to :back
    end
  end

  def reject_locked_topic!
    if @topic.locked?
      flash.alert = t("forem.post.not_created_topic_locked")
      redirect_to [@topic.forum, @topic] and return
    end
  end

  def find_reply_to_post
    @reply_to_post = @topic.posts.find_by_id(params[:reply_to_id])
  end
end
