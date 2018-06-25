class Admins::HpStoreProductCategoriesController < Admins::ApplicationController

  def index
    @hp_stores = HpStore.send(params[:type]).order('created_at asc')
    
    @list = CjAdvertiser.select([:name, :id]).all
    @list += AvantAdvertiser.select([:name, :id]).all
    @list += LinkshareAdvertiser.select([:name, :id]).all
    @list += PjAdvertiser.select([:name, :id]).all
    @list += IrAdvertiser.select([:name, :id]).all
    @list += CustomAdvertiser.select([:name, :id]).all
    @list = @list.sort_by &:name
    
    @product_category = ProductCategory.where(popular: true)
    @product_category = @product_category.sort_by &:name
    @popular_stores = HpStoreProductCategory.all.paginate(:page => params[:page], :per_page => 20)
  end

  def create
    pair = params[:advertiser_id_with_class_name].split('.')
    if pair[0] == CjAdvertiser.name
      hp_fav_store = HpStore.find_or_create_by(cj_advertiser_id: pair[1])
      hp_fav_store.store_type = params[:store_type]
      if hp_fav_store.save
        hp_store_product_category = HpStoreProductCategory.new
        hp_store_product_category.hp_store_id = hp_fav_store.id
        hp_store_product_category.product_category_id = params[:product_category]
        hp_store_product_category.save!
        flash[:notice] = 'Successfully added.'
      else
        flash[:alert] = hp_fav_store.errors.full_messages
      end
    elsif pair[0] == AvantAdvertiser.name
      hp_fav_store = HpStore.find_or_create_by(avant_advertiser_id: pair[1])
      hp_fav_store.store_type = params[:store_type]
      if hp_fav_store.save
        hp_store_product_category = HpStoreProductCategory.new
        hp_store_product_category.hp_store_id = hp_fav_store.id
        hp_store_product_category.product_category_id = params[:product_category]
        hp_store_product_category.save!
        flash[:notice] = 'Successfully added.'
      else
        flash[:alert] = hp_fav_store.errors.full_messages
      end
    elsif pair[0] == LinkshareAdvertiser.name
      hp_fav_store = HpStore.find_or_create_by(linkshare_advertiser_id: pair[1])
      hp_fav_store.store_type = params[:store_type]
      if hp_fav_store.save
        hp_store_product_category = HpStoreProductCategory.new
        hp_store_product_category.hp_store_id = hp_fav_store.id
        hp_store_product_category.product_category_id = params[:product_category]
        hp_store_product_category.save!
        flash[:notice] = 'Successfully added.'
      else
        flash[:alert] = hp_fav_store.errors.full_messages
      end
    elsif pair[0] == PjAdvertiser.name
      hp_fav_store = HpStore.find_or_create_by(pj_advertiser_id: pair[1])
      hp_fav_store.store_type = params[:store_type]
      if hp_fav_store.save
        hp_store_product_category = HpStoreProductCategory.new
        hp_store_product_category.hp_store_id = hp_fav_store.id
        hp_store_product_category.product_category_id = params[:product_category]
        hp_store_product_category.save!
        flash[:notice] = 'Successfully added.'
      else
        flash[:alert] = hp_fav_store.errors.full_messages
      end
    elsif pair[0] == IrAdvertiser.name
      hp_fav_store = HpStore.find_or_create_by(ir_advertiser_id: pair[1])
      hp_fav_store.store_type = params[:store_type]
      if hp_fav_store.save
        hp_store_product_category = HpStoreProductCategory.new
        hp_store_product_category.hp_store_id = hp_fav_store.id
        hp_store_product_category.product_category_id = params[:product_category]
        hp_store_product_category.save!
        flash[:notice] = 'Successfully added.'
      else
        flash[:alert] = hp_fav_store.errors.full_messages
      end
    else
      hp_fav_store = HpStore.find_or_create_by(custom_advertiser_id: pair[1])
      hp_fav_store.store_type = params[:store_type]
      if hp_fav_store.save
        hp_store_product_category = HpStoreProductCategory.new
        hp_store_product_category.hp_store_id = hp_fav_store.id
        hp_store_product_category.product_category_id = params[:product_category]
        hp_store_product_category.save!
        flash[:notice] = 'Successfully added.'
      else
        flash[:alert] = hp_fav_store.errors.full_messages
      end
    end
    redirect_to admin_hp_store_product_categories_path(:type => params[:store_type])
    
  end

 

  def destroy
    @hp_store_product_category = HpStoreProductCategory.find_by_id(params[:id])
    if @hp_store_product_category.destroy
      flash[:notice] = 'Successfully deleted.'
    else
      flash[:alert] = 'Something went wrong, please try again.'
    end
    redirect_to admin_hp_store_product_categories_path(:type => "popular_stores")
  end
  
  private
  
      
  def hp_advertiser_image_params
    params.require(:hp_advertiser_image).permit(:title, :description)
  end


end
