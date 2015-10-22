module Admin
  class ForumsController < BaseController
    include TopicsHelper
    before_filter :find_forum, :only => [:edit, :update, :destroy]

    def index
      @forums = attributes(Forum.all, ['topics'])
      @categories_id_name_map = {}
      attributes(Category.all).each do |c|
        @categories_id_name_map[c['id']] = c['category_name']
      end
      @forum_post_counts = {}
      @forums.each do |forum|
        all_topics = get_topics(forum['id']).map { |t| Topic.new_from_hash(t) }
        topics = attributes(all_topics, ['posts'])
        @forum_post_counts[forum['id']] = topics.inject(0) do |count, topic|
          count + topic['posts'].size
        end
      end
    end

    def new
      @forum = Forem::Forum.new
    end

    def create
      @forum = Forem::Forum.new(forum_params)
      if @forum.save
        create_successful
      else
        create_failed
      end
    end

    def update
      if @forum.update_attributes(forum_params)
        update_successful
      else
        update_failed
      end
    end

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

    def create_failed
      flash.now.alert = t("forem.admin.forum.not_created")
      render :action => "new"
    end

    def destroy_successful
      flash[:notice] = t("forem.admin.forum.deleted")
      redirect_to admin_forums_path
    end

    def update_successful
      flash[:notice] = t("forem.admin.forum.updated")
      redirect_to admin_forums_path
    end

    def update_failed
      flash.now.alert = t("forem.admin.forum.not_updated")
      render :action => "edit"
    end

  end
end
