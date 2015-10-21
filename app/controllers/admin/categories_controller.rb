module Admin
  class CategoriesController < BaseController
    include Connection
    before_filter :find_category, :only => [:edit, :update, :destroy]

    def index
      @categories = attributes(Category.all, ['forums'])
    end

    def new
      @category = Category.new
    end

    def create
      category_name = category_params[:name]
      if attributes(Category.all).find { |c| c['name'] == category_name }
        create_failed "category '#{category_name}' already exists"
        return
      end

      Category.create(name: category_name)
      create_successful
    rescue Exception => e
      Rails.logger.error "Encountered an error: #{e.inspect}\nbacktrace: #{e.backtrace}"
      create_failed t("forem.admin.category.not_created")
      render action: 'new'
    end

    def update
      if @category.update_attributes(category_params)
        update_successful
      else
        update_failed
      end
    end

    def destroy
      @category.destroy
      destroy_successful
    end

    private

    def category_params
      params.require(:category).permit(:name, :position)
    end

    def find_category
      @category = Forem::Category.friendly.find(params[:id])
    end

    def create_successful
      flash[:notice] = t("forem.admin.category.created")
      redirect_to admin_categories_path
    end

    def create_failed(alert_msg)
      flash.now.alert = alert_msg
      @category = Category.new
      render action: 'new'
    end

    def destroy_successful
      flash[:notice] = t("forem.admin.category.deleted")
      redirect_to admin_categories_path
    end

    def update_successful
      flash[:notice] = t("forem.admin.category.updated")
      redirect_to admin_categories_path
    end

    def update_failed
      flash.now.alert = t("forem.admin.category.not_updated")
      render :action => "edit"
    end

  end
end
