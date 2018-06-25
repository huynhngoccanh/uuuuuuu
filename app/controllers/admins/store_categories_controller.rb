class Admins::StoreCategoriesController < Admins::ApplicationController
  # GET /admins/store_categories
  # GET /admins/store_categories.json
  def index
    @admins_store_categories = Admins::StoreCategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @admins_store_categories }
    end
  end

  # GET /admins/store_categories/1
  # GET /admins/store_categories/1.json
  def show
    @admins_store_category = Admins::StoreCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @admins_store_category }
    end
  end

  # GET /admins/store_categories/new
  # GET /admins/store_categories/new.json
  def new
    @admins_store_category = Admins::StoreCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @admins_store_category }
    end
  end

  # GET /admins/store_categories/1/edit
  def edit
    @admins_store_category = Admins::StoreCategory.find(params[:id])
  end

  # POST /admins/store_categories
  # POST /admins/store_categories.json
  def create
    @admins_store_category = Admins::StoreCategory.new(params[:admins_store_category])

    respond_to do |format|
      if @admins_store_category.save
        format.html { redirect_to @admins_store_category, :notice => 'Store category was successfully created.' }
        format.json { render :json => @admins_store_category, :status => :created, :location => @admins_store_category }
      else
        format.html { render :action => "new" }
        format.json { render :json => @admins_store_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admins/store_categories/1
  # PUT /admins/store_categories/1.json
  def update
    @admins_store_category = Admins::StoreCategory.find(params[:id])

    respond_to do |format|
      if @admins_store_category.update_attributes(params[:admins_store_category])
        format.html { redirect_to @admins_store_category, :notice => 'Store category was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @admins_store_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admins/store_categories/1
  # DELETE /admins/store_categories/1.json
  def destroy
    @admins_store_category = Admins::StoreCategory.find(params[:id])
    @admins_store_category.destroy

    respond_to do |format|
      format.html { redirect_to admins_store_categories_url }
      format.json { head :ok }
    end
  end
end
