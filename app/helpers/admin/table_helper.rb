module Admin
  module TableHelper

    ALIGN_CLASSES = {left: 't-left', center: 't-center', right: 't-right'}

    def table_for(a_class)
      Coalla::TableBuilder.new(self, a_class)
    end

    def edit_link(path)
      return unless policy.action_enabled?(:edit)
      content = "<i class='glyphicon glyphicon-pencil'></i>".html_safe
      link_to content, path, class: 'btn btn-default btn-xs', title: I18n.t('admin.common.edit')
    end

    def delete_link(path)
      return unless policy.action_enabled?(:destroy)
      content = "<i class='glyphicon glyphicon-trash'></i>".html_safe
      link_to content, path, data: {confirm: I18n.t('admin.common.sure')}, method: :delete, class: 'btn btn-danger btn-xs', title: I18n.t('admin.common.delete')
    end

    def th_class(column)
      klass = []
      klass << "col-xs-#{column.cols}" if column.cols
      klass << ALIGN_CLASSES[column.align] if column.align
      klass.join(' ')
    end

    def tr_class(row_class, item)
      row_class && row_class.call(item)
    end

    def td_class(column)
      klass = []
      klass << column.col_class
      klass << ALIGN_CLASSES[column.align] if column.align
      klass.join(' ')
    end
  end
end