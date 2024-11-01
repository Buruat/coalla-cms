module Coalla
  class TableFormatter
    # TODO (vl): move formatters to separate files and lambdas

    class SimpleFormatter
      def format_value(item, format)
        return '' unless item
        return format.call(item) if format.is_a?(Proc)
        customize(item)
      end

      def customize(item)
        item
      end
    end

    class BooleanFormatter < SimpleFormatter
      def customize(item)
        item ? '<i class="glyphicon glyphicon-check"></i>'.html_safe : ''
      end

      def align
        :center
      end
    end

    class DateFormatter < SimpleFormatter
      def initialize(default_format = '%d.%m.%Y')
        @default_format = default_format
      end

      def customize(item)
        item = item.localtime if item.respond_to?(:localtime)
        Russian::strftime(item, @default_format)
      end
    end

    class EnumerizeFormatter < SimpleFormatter
      def customize(item)
        item.try(:text)
      end
    end

    class SelfFormatter
      def format_value(item, format)
        raise 'Format should be lambda' unless format.is_a?(Proc)
        format.call(item)
      end
    end

    class ReflectionFormatter
      def initialize(method)
        @method = method
      end

      def format_value(item, format)
        target = item.send(@method)
        raise 'Format should be lambda' unless format.is_a?(Proc)
        format.call(target)
      end
    end

    class MethodFormatter
      FORMATS = {
          boolean: BooleanFormatter.new,
          date: DateFormatter.new,
          datetime: DateFormatter.new('%d.%m.%Y %H:%M'),
          enumerize: EnumerizeFormatter.new
      }

      FORMATS.default = SimpleFormatter.new

      def initialize(method, type)
        @method = method
        @formatter = FORMATS[type]
      end

      def format_value(item, format)
        @formatter.format_value(item.send(@method), format)
      end

      def align
        @align || @formatter.respond_to?(:align) && @formatter.align || :left
      end

      def align=(value)
        @align = value
      end

      def respond_to?(method)
        return (@align.present? || @formatter.respond_to?(method)) if method == :align
        super
      end
    end

    def initialize(model_class)
      @model_class = model_class
      @columns = model_class.columns.index_by(&:name).with_indifferent_access
      @reflections = model_class.reflections.dup.with_indifferent_access
      @helpers = {}
    end

    def self.for(model_class)
      new(model_class)
    end

    def [](method)
      return @helpers[method] if @helpers[method]
      @helpers[method] = load_helper(method)
      @helpers[method]
    end

    private

    def load_helper(method)
      return SelfFormatter.new if method == :self

      reflection = @reflections[method]
      return ReflectionFormatter.new(method) if reflection && reflection.macro == :belongs_to

      # TODO (vl): refactor this
      if @model_class.respond_to?(:enumerized_attributes) && @model_class.enumerized_attributes[method]
        type = :enumerize
      else
        type = @columns[method] && @columns[method].type || :default
      end

      helper = MethodFormatter.new(method, type)
      helper.align = :right if [:integer, :float, :decimal].include?(type.to_sym)
      helper
    end
  end
end