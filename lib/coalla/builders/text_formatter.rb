module Coalla
  class TextFormatter
    def initialize(object)
      @object = object
      # TODO (vl): refactor this
      @columns = @object.class.columns.index_by(&:name).with_indifferent_access
    end

    def format(method)
      method_value = @object.send(method)
      return unless method_value

      method_type = @columns[method].try(:type)
      if method_type == :datetime
        method_value = method_value.localtime if method_value.respond_to?(:localtime)
        Russian.strftime(method_value, '%d.%m.%Y %H:%M')
      else
        method_value
      end
    end
  end
end