module Admin
  class ForumsController < BaseController
    include ForumsHelper, TopicsHelper, GroupHelper, UsersHelper

    def index
      @forums = attributes(Forum.all, ['topics', 'moderators'])
      @categories_id_name_map = {}
      attributes(Category.all).each do |c|
        @categories_id_name_map[c['id']] = c['category_name']
      end
      @forum_post_counts = Hash.new(0)
      @forum_last_post = {}
      @forums.each do |forum|
        all_topics = forum['topics'].map { |t| Topic.new_from_hash(t) }
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

      mappings = user_mappings(@forum_last_post.map { |forum_id, post| post['user_id'] })
      @forum_last_post.each do |forum_id, post|
        user = mappings[post['user_id']]
        post['user'] = user.name
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
        error_msg += 'Description can not be empty!'
      end

      unless error_msg.blank?
        fail error_msg
      end

      error_msg = nil
      if params[:forum_id].blank?
        c = find_forum_by_name(category, forum_name)
        Rails.logger.info "find_forum_by_name #{category} #{forum_name}: #{c.inspect}"
        unless c.empty?
          error_msg = "Forum '#{forum_name}' already exists"
          fail error_msg
        end
        create_forum(category, forum_name, description, forum_params['moderator_ids'])
        create_successful
      else
        key = {category: category, id: params[:forum_id]}
        forum = Forum.new_from_hash(get(Forum, key))
        update(Forum, key, 'SET forum_name = :val', {':val' => forum_name}) if forum.forum_name != forum_name
        update(Forum, key, 'SET description = :val', {':val' => description}) if forum.description != description
        original_moderators = forum.moderators.map { |group| group['id'] }
        to_add = forum_params['moderator_ids'] - original_moderators
        to_remove = original_moderators - forum_params['moderator_ids']
        to_add.each do |group|
          ModeratorGroup.create(group: group, forum: forum.id)
        end
        to_remove.each do |group|
          delete(ModeratorGroup, {forum: forum.id, group: group})
        end
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

    def edit
      get_forum_from_params params['category'], :id
    end

    def destroy
      delete_forum(params[:category], params[:id])
      destroy_successful
    end

    private

    def forum_params
      params.require(:forum).permit(:category_id, :title, :description, :position, {:moderator_ids => []})
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
      get_forum_from_params params['forum']['category'], :forum_id
      render action: 'edit'
    end

    def for_new_forum
      @categories = attributes(Category.all)
      @forum = Forum.new
      @groups = attributes(Group.all)
    end

    def get_forum_from_params(category, id_key)
      for_new_forum
      @category = get(Category, {id: category})
      forum = get(Forum, {category: category, id: params[id_key]})
      @forum = Forum.new_from_hash(forum)
      @forum_moderators = @forum.moderators.map { |m| m['id'] }
    end

  end
end
