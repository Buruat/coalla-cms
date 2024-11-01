require 'coalla/builders/column_definition'
require 'coalla/builders/actions_column_definition'
require 'coalla/builders/table_formatter'

module Coalla
  class TableBuilder
    def initialize(context, model_class, options = {})
      @context, @model_class = context, model_class
      @options = options
      @columns = []
      @table_formatter = TableFormatter.for(@model_class)
    end

    def content(collection, &block)
      @collection = collection
      block.call(self) if block_given?
      create_content
    end

    # Метод добавляет столбец к таблице
    def column(method, options = {})
      helper = @table_formatter[method]
      cd = ColumnDefinition.new
      cd.title = options[:title] || I18n.t("activerecord.attributes.#{@model_class.model_name.singular}.#{method}")
      cd.cols = options[:cols]
      cd.col_class = options[:class]
      cd.sort = sort_value(method, options.fetch(:sort, false))
      cd.edit = edit_options(method, options.fetch(:edit, false))
      cd.value_extractor = ->(item) { helper.format_value(item, options[:format]) }
      cd.align = options[:align] || helper.respond_to?(:align) && helper.align
      @columns << cd
    end

    # Метод позволяет передать блок, который должен вычислять класс для строки. В этот блок передается объект,
    # по которому данная строка рендерится. Таким образом, можно управлять, например, цветом строки в зависимости
    # от состояния объекта (статусы заказов и прочее).
    def row_class(lmb)
      @row_class = lmb
    end

    # Метод добавляет кнопку в столбец действий
    def action(value, options = {})
      add_action(value, options)
    end

    # Метод добавляет кнопку редактирования сущности в столбец действий
    def edit(options = {})
      add_action(:edit, options)
    end

    # Метод добавляет кнопку удаления сущности в столбец действий
    def delete(options = {})
      add_action(:delete, options)
    end

    # Метод добавляет кнопки добавления и удаления сущностей в столбец действий
    def edit_and_delete(options = {})
      self.edit(options)
      self.delete(options)
    end

    private

    def add_action(value, options)
      action_name = value.is_a?(Proc) ? options[:action_name] : value
      return unless policy.action_enabled?(action_name, options)
      @action_definition ||= ActionsColumnDefinition.new
      @action_definition.action(value, options)
      if @columns.exclude?(@action_definition)
        @columns << @action_definition
      end
    end

    def sort_value(method, sort_option)
      return sort_option.to_s if sort_option.is_a?(String) || sort_option.is_a?(Symbol)
      method.to_s if sort_option
    end

    def edit_options(method, options)
      return unless options
      result_options = {column: method}
      if options.is_a?(Hash)
        result_options.merge!(options)
      else
        result_options
      end
      return false unless policy.field_enabled?(result_options[:column])
      result_options
    end

    def create_content
      @context.render(partial: '/admin/common/table_template', locals: {definitions: @columns, items: @collection, row_class: @row_class})
    end

    def policy
      @policy ||= @context.try(:policy) || Coalla.policy.new(@context)
    end
  end
end