module Admin
  module ResourceHelpers
    extend ActiveSupport::Concern

    included do
      before_action :load_resource!, only: [:edit, :update, :destroy]
      before_action :build_resource, only: [:new, :create]

      helper_method :resource, :resources, :resource_name, :resource_model
    end

    def index
      instance_variable_set("@#{resource_name.pluralize}", resource_model.order(created_at: :desc).paginate(page: params[:page], per_page: per_page))
    end

    def new; end

    def create
      apply(:new)
    end

    def edit; end

    def update
      apply
    end

    def destroy
      resource.destroy!
      redirect_to_last
    end

    def apply(partial = :edit)
      resource.assign_attributes(resource_params)
      if resource.save
        redirect_after_save
      else
        render partial
      end
    end

    def redirect_or_render(partial)
      if params[:save].present?
        redirect_to_back
      else
        add_success_msg
        render partial
      end
    end

    def redirect_after_save(options = {})
      if params[:save].present?
        redirect_to_back
      else
        add_success_msg(false)
        path = options.fetch(:path, url_for(action: :edit, id: resource))
        redirect_to path
      end
    end

    def resource
      instance_variable_get("@#{resource_name}")
    end

    def resources
      instance_variable_get("@#{resource_name.pluralize}")
    end

    def load_resource!
      instance_variable_set("@#{resource_name}", resource_model.find(params[:id]))
    end

    def build_resource(attributes = {})
      instance_variable_set("@#{resource_name}", resource_model.new(attributes))
    end

    def resource_model
      resource_name.classify.constantize
    end

    def resource_params
      params[resource_name.to_sym].permit!
    end

    def resource_name
      controller_name.singularize
    end

    def add_success_msg(now = true)
      message = I18n.t('admin.common.save_success')
      if now
        flash.now[:admin_success] = message
      else
        flash[:admin_success] = message
      end
    end

    def per_page
      20
    end
  end
end