require 'set'

class PostsController < ApplicationController
  include PostsHelper, UsersHelper

  before_filter :authenticate_forem_user, except: [:index, :show]
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
                body_text: params['text'],
                user_id: current_user.id)
    render json: {success: true}
  rescue Exception => e
    Rails.logger.error "Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}"
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end

  def update
    render json: {success: true}
  rescue Exception => e
    Rails.logger.error "Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}"
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end

  def destroy
    delete_post(params[:topic_id], params[:id])
    render json: {success: true}
  rescue Exception => e
    Rails.logger.error "Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}"
    render json: {message: e.to_s}.to_json, status: :internal_server_error
  end

end
