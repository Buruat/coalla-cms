module Admin
  module SortableColumns
    def sortable_columns(*args, **keyword_args)
      sort_columns = args.map(&:to_s)
      default_sort_order = keyword_args.fetch(:default, sort_columns.first)

      define_method :sort_order do
        sort_column = sort_columns.find { |column| column == params[:sort_by] }
        sort_direction = %w(asc desc).find { |column| column == params[:sort_direction].to_s.downcase }
        sort_column && sort_direction ? "#{sort_column} #{sort_direction}" : default_sort_order
      end

      helper_method :sort_order
    end
  end
end