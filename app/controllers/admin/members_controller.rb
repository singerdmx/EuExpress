module Admin
  class MembersController < BaseController
    include GroupHelper

    def add
      user_id = params[:user_id].to_i
      user = User.friendly.find(user_id)
      unless group_members.include?(user.id)
        Membership.create(user_group_membership_key(user_id))
      end
      redirect_to group_url(group.id, group.name)
    end

    def destroy
      user_id = params[:id].to_i
      user = User.friendly.find(user_id)
      if group_members.include?(user.id)
        delete(Membership, user_group_membership_key(user_id))
        flash[:notice] = t("forem.admin.groups.show.member_removed")
      else
        flash[:alert] = t("forem.admin.groups.show.no_member_to_remove")
      end
      redirect_to group_url(group.id, group.name)
    end

    private

    def group
      @group ||= Group.new_from_hash(get(Group, {id: params[:group_id]}))
    end

    def group_members
      @group_members ||= group.members.map { |m| m['user_id'] }
    end

    def user_group_membership_key(user_id)
      {group_id: params[:group_id], user_id: user_id}
    end
  end
end
