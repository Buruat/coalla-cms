module Admin

  class LookupsController < BaseController

    def index
      @category = params[:category]
      @lookups = Lookup.where(category: @category).order(:code, :created_at)
      if @lookups.blank? && @category.present?
        redirect_to admin_lookups_index_path
        return
      end
    end

    def new
      @lookup = Lookup.new
    end

    def create
      @lookup = Lookup.new(params[:lookup])
      if @lookup.save
        redirect_to admin_lookups_index_path(category: @lookup.category)
      else
        render :new
      end
    end

    def show
      @lookup = Lookup.find(params[:id])
    end

    def edit
      @lookup = Lookup.find(params[:id])
    end

    def update
      @lookup = Lookup.find(params[:id])
      if @lookup.update_attributes(params[:lookup].permit!)
        redirect_to admin_lookups_index_path(category: @lookup.category)
      else
        render :edit
      end
    end

    def destroy
      @lookup = Lookup.find(params[:id])
      @lookup.destroy
      redirect_to admin_lookups_index_path(category: @lookup.category)
    end

  end

end