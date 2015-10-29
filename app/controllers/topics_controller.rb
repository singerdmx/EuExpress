require 'set'

class TopicsController < ApplicationController
  helper PostsHelper
  include TopicsHelper, UsersHelper

  before_filter :authenticate_forem_user, except: [:index, :show]
  before_filter :find_topic, only: [:show]
  before_filter :block_spammers, only: [:new, :create]

  def index
    fail 'params forum_id is undefined!' unless params[:forum_id]
    all_topics = get_topics(params[:forum_id]).map { |t| Topic.new_from_hash(t) }
    topics = attributes(all_topics).map do |t|
      simple_topic_hash(t)
    end

    user_ids = Set.new
    topics.each do |topic|
      user_ids.add(topic['user_id'])
      user_ids.add(topic['last_post_by'])
    end
    mappings = user_mappings(user_ids)
    topics.each do |topic|
      topic['user'] = simple_user_hash(mappings[topic['user_id']])
      topic.delete('user_id')
      topic['last_post_by'] = simple_user_hash(mappings[topic['last_post_by']])
    end

    if stale?(etag: topics, last_modified: max_updated_at(all_topics))
      render json: topics
    else
      head :not_modified
    end
  rescue Exception => e
    Rails.logger.error "Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}"
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end

  def show
    register_view_by(current_user, Topic, @topic['id'],
                     {forum: params[:forum_id], id: params[:id]})
    render json: simple_topic_hash(@topic)
  end

  def new
    authorize! :create_topic, @forum
    @topic = @forum.topics.build
    @topic.posts.build
  end

  def create
    authorize! :create_topic, @forum
    @topic = @forum.topics.build(topic_params)
    @topic.user = forem_user
    if @topic.save
      create_successful
    else
      create_unsuccessful
    end
  end

  def destroy
    @topic = @forum.topics.friendly.find(params[:id])
    if forem_user == @topic.user || forem_user.forem_admin?
      @topic.destroy
      destroy_successful
    else
      destroy_unsuccessful
    end
  end

  def subscribe
    if find_topic
      @topic.subscribe_user(forem_user.id)
      subscribe_successful
    end
  end

  def unsubscribe
    if find_topic
      @topic.unsubscribe_user(forem_user.id)
      unsubscribe_successful
    end
  end

  protected

  def topic_params
    params.require(:topic).permit(:subject, :posts_attributes => [[:text]])
  end

  def create_successful
    redirect_to [@forum, @topic], :notice => t("forem.topic.created")
  end

  def create_unsuccessful
    flash.now.alert = t('forem.topic.not_created')
    render :action => 'new'
  end

  def destroy_successful
    flash[:notice] = t("forem.topic.deleted")

    redirect_to @topic.forum
  end

  def destroy_unsuccessful
    flash.alert = t("forem.topic.cannot_delete")

    redirect_to @topic.forum
  end

  def subscribe_successful
    flash[:notice] = t("forem.topic.subscribed")
    redirect_to forum_topic_url(@topic.forum, @topic)
  end

  def unsubscribe_successful
    flash[:notice] = t("forem.topic.unsubscribed")
    redirect_to forum_topic_url(@topic.forum, @topic)
  end

  private
  def find_forum
    @forum = Forem::Forum.friendly.find(params[:forum_id])
    authorize! :read, @forum
  end

  def find_posts(topic)
    posts = topic.posts
    unless forem_admin_or_moderator?(topic.forum)
      posts = posts.approved_or_pending_review_for(forem_user)
    end
    @posts = posts
  end

  def block_spammers
    if forem_user.forem_spammer?
      flash[:alert] = t('forem.general.flagged_for_spam') + ' ' +
          t('forem.general.cannot_create_topic')
      redirect_to :back
    end
  end

  def forum_topics(forum, user)
    if forem_admin_or_moderator?(forum)
      forum.topics
    else
      forum.topics.visible.approved_or_pending_review_for(user)
    end
  end
end
