module Admin
  class GroupsController < BaseController
    include GroupHelper
    before_filter :find_group, only: [:show, :destroy]

    def index
      @groups = attributes(Group.all)
    end

    def new
      @group = Group.new
    end

    def create
      group_name = params[:name]
      error_msg = nil
      if group_name.blank?
        error_msg = 'Group name can not be empty!'
        fail error_msg
      end

      if attributes(Group.all).find { |c| c['group_name'] == group_name }
        error_msg = "group '#{group_name}' already exists"
        fail error_msg
      end
      group = Group.create(name: group_name)
      create_successful(group.id, group_name)
    rescue Exception => e
      Rails.logger.error "Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}"
      create_failed error_msg || t("forem.admin.group.created")
    end

    def destroy
      @group.destroy
      flash[:notice] = t("forem.admin.group.deleted")
      redirect_to admin_groups_path
    end

    private

    def find_group
      @group = Group.new_from_hash(get(Group, id: params[:id]))
    end

    def group_params
      params.require(:group).permit(:name)
    end

    def create_successful(group_id, group_name)
      redirect_to group_url(group_id, group_name)
    end

    def create_failed(alert_msg)
      flash[:error] = alert_msg
      @group = Group.new
      render action: 'new'
    end
  end
end
