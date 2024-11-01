module Admin

  class AdministratorsController < BaseController

    def update
      success = administrator_params[:password].present? ? resource.update(administrator_params) : resource.update_without_password(resource_params)
      sign_in(resource, bypass: true) if current_administrator == resource
      if success
        redirect_or_render :edit
      else
        render :edit
      end
    end

  end

end