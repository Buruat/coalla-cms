module Admin
  module AlertsHelper
    def flash_warning_messages
      render_alert(flash[:admin_warning], :warning)
    end

    def flash_danger_messages
      render_alert(flash[:admin_danger], :danger)
    end

    def flash_success_messages
      render_alert(flash[:admin_success], :success)
    end

    def flash_messages
      [flash_danger_messages, flash_warning_messages, flash_success_messages].compact.join.html_safe
    end

    def render_alert(message, alert_class)
      return unless message
      "<div class='row'>
      <div class='col-md-8 col-md-offset-2'>
        <div class='alert alert-#{alert_class}'>
          <button data-dismiss='alert' class='close' type='button'>&times;</button>
          <p>#{message}</p>
        </div>
      </div>
    </div>".html_safe
    end
  end
end