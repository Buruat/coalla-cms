module ActionDispatch::Routing

  class Mapper

    def sortable
      collection do
        get :sort
        post '/sort' => :apply_sort
      end
    end

    def editable_columns
      member do
        get :edit_column
        put :update_column
      end
    end

  end

end