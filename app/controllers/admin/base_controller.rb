module Admin

  class BaseController < ApplicationController
    layout 'admin'

    include Admin::PathHistory
    include Admin::ResourceHelpers
    extend Admin::SortableColumns

    helper_method :back_uri, :policy

    before_action :no_cache!
    before_action :authenticate_administrator!
    before_action :load_structure
    before_action :store_path_history
    before_action :action_enabled?

    def policy
      @policy ||= Coalla.policy.new(self)
    end

    delegate :sanitize_params, to: :policy

    protected

    def load_structure
      @structure = Coalla::AdminStructure.new(self, Rails.application.routes)
    end

    def action_enabled?
      redirect_to request.referer.presence || '/admin' unless policy.action_enabled?(action_name)
    end
  end

end
