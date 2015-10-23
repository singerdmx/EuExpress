module Admin
  class ForumsController < BaseController
    include ForumsHelper, TopicsHelper, GroupHelper

    def index
      @forums = attributes(Forum.all, ['topics', 'moderators'])
      @categories_id_name_map = {}
      attributes(Category.all).each do |c|
        @categories_id_name_map[c['id']] = c['category_name']
      end
      @forum_post_counts = Hash.new(0)
      @forum_last_post = {}
      @forums.each do |forum|
        all_topics = get_topics(forum['id']).map { |t| Topic.new_from_hash(t) }
        topics = attributes(all_topics, ['posts'])
        topics.each do |topic|
          @forum_post_counts[forum['id']] += topic['posts'].size
          unless topic['posts'].empty?
            topic_last_post = topic['posts'].first
            if @forum_last_post[forum['id']].nil? || topic_last_post['updated_at'] > @forum_last_post[forum['id']]['updated_at']
              topic_last_post['topic'] = topic
              @forum_last_post[forum['id']] = topic_last_post
            end
          end
        end
      end

      @forum_last_post.each do |forum_id, post|
        post['user'] = User.find(post['user_id']).name
      end
    end

    def new
      for_new_forum
    end

    def create
      error_msg = ''
      forum_name = params['name']
      description = params['description']
      category = params['forum']['category']
      if forum_name.blank?
        error_msg = 'Category name can not be empty! '
      end

      if description.blank?
        error_msg = 'Description can not be empty!'
      end

      unless error_msg.blank?
        fail error_msg
      end

      error_msg = nil

      c = find_forum_by_name(category, forum_name)
      Rails.logger.info "find_forum_by_name #{category} #{forum_name}: #{c.inspect}"
      unless c.empty?
        error_msg = "Forum '#{forum_name}' already exists"
        fail error_msg
      end
      if params[:forum_id].blank?
        create_successful
      else
        update_successful
      end
    rescue Exception => e
      Rails.logger.error "Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}"
      if params[:forum_id].blank?
        create_failed error_msg || t("forem.admin.forum.not_created")
      else
        update_failed error_msg || t("forem.admin.category.not_updated")
      end
    end

    # def update
    #   if @forum.update_attributes(forum_params)
    #     update_successful
    #   else
    #     update_failed
    #   end
    # end

    def destroy
      @forum.destroy
      destroy_successful
    end

    private

    def forum_params
      params.require(:forum).permit(:category_id, :title, :description, :position, {:moderator_ids => []})
    end

    def find_forum
      @forum = Forem::Forum.friendly.find(params[:id])
    end

    def create_successful
      flash[:notice] = t("forem.admin.forum.created")
      redirect_to admin_forums_path
    end

    def create_failed(alert_msg)
      flash.now.alert = alert_msg
      for_new_forum
      render action: 'new'
    end

    def destroy_successful
      flash[:notice] = t("forem.admin.forum.deleted")
      redirect_to admin_forums_path
    end

    def update_successful
      flash[:notice] = t("forem.admin.forum.updated")
      redirect_to admin_forums_path
    end

    def update_failed(alert_msg)
      flash.now.alert = alert_msg
      render action: 'edit'
    end

    def for_new_forum
      @categories = attributes(Category.all)
      @forum = Forum.new
      moderator_group_ids = attributes(ModeratorGroup.all).map {|g| g['group']}.uniq
      @moderator_groups = batch_get_groups(moderator_group_ids)
    end

  end
end
