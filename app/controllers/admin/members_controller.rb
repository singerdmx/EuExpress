module Admin
  class MembersController < BaseController
    def add
      user = Forem.user_class.friendly.find(params[:user_id])
      unless group.members.exists?(user.id)
        group.members << user
      end
      redirect_to [:admin, group]
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
      @group ||= Forem::Group.find(params[:group_id])
    end
  end
end