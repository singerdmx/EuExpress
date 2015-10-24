module Admin
  class MembersController < BaseController
    def add
      user_id = params[:user_id]
      group_id = params[:group_id]
      user = User.friendly.find(user_id)
      group_members = group.members.map { |m| m['user_id'] }
      unless group_members.include?(user.id)
        Membership.create(group_id: group_id, user_id: user_id)
      end
      redirect_to "/admin/groups/#{group_id}?name=#{group.name}"
    end

    def destroy
      user = Forem.user_class.friendly.find(params[:id])
      if group.members.exists?(user.id)
        group.members.delete(user)
        flash[:notice] = t("forem.admin.groups.show.member_removed")
      else
        flash[:alert] = t("forem.admin.groups.show.no_member_to_remove")
      end
      redirect_to [:admin, group]
    end

    private

    def group
      @group ||= Group.new_from_hash(get(Group, {id: params[:group_id]}))
    end
  end
end
