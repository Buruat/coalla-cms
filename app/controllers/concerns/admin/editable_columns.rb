module Admin
  module EditableColumns
    include Admin::AlertsHelper
    extend ActiveSupport::Concern

    included do
      helper_method :controller_model
    end

    def edit_column
      item = controller_model.find(params[:id])
      form = render_to_string('admin/editable_columns/edit_column', locals: {item: item, column_partial: column_partial(:edit), options: OpenStruct.new(params)}, layout: false)
      render json: {form: form}
    end

    def update_column
      item = controller_model.find(params[:id])

      unless item.update(column_params)
        messages = item.errors.full_messages.join("</br>")
        alert = render_alert(messages, :danger)
        render json: {alert: alert}
        return
      end

      result = render_to_string(partial: column_partial(:result), locals: {item: item, options: OpenStruct.new(params)})
      render json: {result: result}
    end

    def controller_model
      controller_name.singularize.camelize.constantize
    end

    def column_partial(operation)
      column = params[:column]

      return "#{operation}_#{column}" if params[:custom].presence

      # TODO (vl): refactor this
      if controller_model.respond_to?(:enumerized_attributes) && controller_model.enumerized_attributes[column]
        type = :enumerize
      else
        columns_info = controller_model.columns.index_by(&:name).with_indifferent_access
        type = columns_info[column].type
        type = :string if %i(integer float decimal).include?(type)
      end

      "admin/editable_columns/#{operation}/#{type}"
    end

    def column_params
      sanitize_params(params.require(:item).permit!)
    end
  end
end