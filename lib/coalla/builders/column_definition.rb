module Coalla
  class ColumnDefinition
    attr_accessor :title, :cols, :col_class, :value_extractor, :align, :sort, :edit

    def value(item, context = self)
      self.value_extractor.call(item)
    end
  end
end