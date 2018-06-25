class Admins::ProductCategoriesController < Admins::ApplicationController
  # GET /admins/store_categories
  # GET /admins/store_categories.json
  def index
    @product_categories = ProductCategory.order('name').paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @product_categories }
    end
  end

  # GET /admins/store_categories/1
  # GET /admins/store_categories/1.json
  def show
    @product_category = ProductCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @product_category }
    end
  end

  # GET /admins/store_categories/new
  # GET /admins/store_categories/new.json
  def new
    @product_category = ProductCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @product_category }
    end
  end

  # GET /admins/store_categories/1/edit
  def edit
    @product_category = ProductCategory.find(params[:id])
  end

  # POST /admins/store_categories
  # POST /admins/store_categories.json
  def create
    @product_category = ProductCategory.new(product_categories_params)

    respond_to do |format|
      if @product_category.save
        format.html { redirect_to admins_product_categories_path, :notice => 'Store category was successfully created.' }
        format.json { render :json => @product_category, :status => :created, :location => @product_category }
      else
        format.html { render :action => "new" }
        format.json { render :json => @product_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admins/store_categories/1
  # PUT /admins/store_categories/1.json
  def update
    @product_category = ProductCategory.find(params[:id])
    if @product_category.update_attributes(product_categories_params)
      redirect_to admins_product_categories_path, :notice => 'Product category was successfully updated.' 
      
    else
      format.html { render :action => "edit" }
      format.json { render :json => @product_category.errors, :status => :unprocessable_entity }
    end
    
  end

  # DELETE /admins/store_categories/1
  # DELETE /admins/store_categories/1.json
  def destroy
    @product_category = ProductCategory.find(params[:id])
    @product_category.destroy

    respond_to do |format|
      format.html { redirect_to admins_product_categories_url }
      format.json { head :ok }
    end
  end
  
  def product_categories_params
    params.require(:product_category).permit(:id, :name, :ancestry, :order, :popular)
  end
end
