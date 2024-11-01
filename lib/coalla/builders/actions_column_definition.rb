module Coalla
  class ActionsColumnDefinition < ColumnDefinition
    def initialize
      self.title = I18n.t('admin.common.actions')
      @actions = []
    end

    def cols
      @cols || @actions.size % 2 + @actions.size / 2
    end

    def col_class
      "col-xs-#{cols}"
    end

    def cols=(value)
      @cols = value
    end

    def value(item, context = self)
      @actions.collect do |action|
        options = action.second
        if options[:if]
          context.instance_exec(item, &action.first) if options[:if].call(item)
        else
          context.instance_exec(item, &action.first)
        end
      end.compact.join(' ').html_safe
    end

    def action(method, options = {})
      @actions << case method
                    when :edit
                      [->(item) { edit_link(url_for(action: :edit, id: item)) }, options.merge(action_name: :edit)]
                    when :delete
                      [->(item) { delete_link(url_for(action: :destroy, id: item)) }, options.merge(action_name: :destroy)]
                    when Proc
                      [method, options]
                    else
                      raise "unsupported method: #{method.inspect}"
                  end
    end
  end
end