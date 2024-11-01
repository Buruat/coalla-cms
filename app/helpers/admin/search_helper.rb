# encoding: utf-8
# frozen_string_literal: true
module Admin
  module SearchHelper
    class FormBuilder < ActionView::Helpers::FormBuilder
      delegate :content_tag, to: :@template

      %w(text_field text_area password_field).each do |method_name|
        define_method(method_name) do |name, *args|
          options = args.extract_options!
          args << { class: 'form-control', style: 'margin-right: 5px;' }.merge(options)
          content_tag :div, class: 'form-group col-md-2' do
            super(name, *args)
          end
        end
      end

      def select(method, choices = nil, options = {}, html_options = {}, &block)
        content_tag :div, class: 'form-group col-md-2' do
          super(method, choices, options, { class: 'form-control', style: 'margin-right: 5px;' }.merge(html_options), &block)
        end
      end

      def collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
        content_tag :div, class: 'form-group col-md-2' do
          super(method, collection, value_method, text_method, options, { class: 'form-control', style: 'margin-right: 5px;' }.merge(html_options))
        end
      end
    end

    def search_form(path = url_for(action: :index), &block)
      content_tag(:div, class: 'well') do
        form_for @q, url: path, method: :get, style: 'margin-top: 20px;', builder: Admin::SearchHelper::FormBuilder do |f|
          [
            hidden_field_tag(:sort_by, params[:sort_by]),
            hidden_field_tag(:sort_direction, params[:sort_direction]),
            search_form_content(f, &block),
            search_form_submit_button,
            search_form_cancel_button(path)
          ].join.html_safe
        end
      end
    end

    private

    def search_form_content(f, &block)
      content_tag(:div, class: 'row') do
        capture(f, &block)
      end
    end

    def search_form_submit_button
      content_tag(:button, type: 'submit', class: 'btn btn-success') do
        content_tag(:i, nil, class: 'glyphicon glyphicon-search') + '&nbsp;Применить'.html_safe
      end
    end

    def search_form_cancel_button(index_action_path)
      link_to('Сбросить', index_action_path, class: 'btn btn-default')
    end
  end
end
