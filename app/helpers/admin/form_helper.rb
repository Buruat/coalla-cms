# encoding: utf-8
# frozen_string_literal: true
module Admin
  module FormHelper
    def twitter_form_for(name, *args, &block)
      options = args.extract_options!
      form_for(name, *(args << {builder: Coalla::FormBuilder, html: {class: 'form-horizontal'}}.deep_merge(options)), &block)
    end

    def field_set(title = nil, options = {}, &block)
      content = capture(self, &block)
      content = content_tag(:legend, title) + content if title
      content_tag :fieldset, content, options
    end

    def actions(&block)
      content = capture(self, &block)
      content_tag(:div, content, class: 'well') if content.present?
    end

    def standard_actions(form)
      fixed_actions { form.save + form.apply + form.cancel }
    end

    def fixed_actions(&block)
      panel_tag = actions(&block)
      content_tag :div, panel_tag, class: 'action-bar'
    end

    def create_link(path = url_for(action: :new))
      return unless policy.action_enabled?(:create)
      content = "<i class='glyphicon glyphicon-plus'></i>&nbsp;&nbsp;#{I18n.t('admin.common.new')}".html_safe
      link_to content, path, class: 'btn btn-success'
    end

    def sort_link(path = url_for(action: :sort))
      return unless policy.action_enabled?(:sort)
      content = "<i class='glyphicon glyphicon-random'></i>&nbsp;&nbsp;#{I18n.t('admin.common.sort')}".html_safe
      link_to content, path, class: 'btn btn-primary'
    end

    def cancel_action(path, name = I18n.t('admin.common.cancel'))
      link_to name, path, class: 'btn btn-default'
    end

    def back_action(name = I18n.t('admin.common.return'), path = back_uri)
      link_to name, path, class: 'btn btn-default'
    end
  end
end