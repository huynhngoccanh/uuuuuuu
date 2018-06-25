class Admins::HpStoresController < Admins::ApplicationController

  def index
    @hp_stores = HpStore.send(params[:type]).order('created_at asc')
    non_cj_advs = HpStore.non_hp_stores(CjAdvertiser.name, params[:type])
    non_avant_advs = HpStore.non_hp_stores(AvantAdvertiser.name, params[:type])
    non_ls_advs = HpStore.non_hp_stores(LinkshareAdvertiser.name, params[:type])
    non_pj_advs = HpStore.non_hp_stores(PjAdvertiser.name, params[:type])
    non_ir_advs  = HpStore.non_hp_stores(IrAdvertiser.name, params[:type])
    non_custom_advs  = HpStore.non_hp_stores(CustomAdvertiser.name, params[:type])
    
    @list =   (non_cj_advs.blank?) ? CjAdvertiser.select([:name, :id]).all : non_cj_advs
    @list += (non_avant_advs.blank?) ? AvantAdvertiser.select([:name, :id]).all : non_avant_advs
    @list += (non_ls_advs.blank?) ? LinkshareAdvertiser.select([:name, :id]).all : non_ls_advs
    @list += (non_pj_advs.blank?) ? PjAdvertiser.select([:name, :id]).all : non_pj_advs
    @list += (non_ir_advs.blank?) ? IrAdvertiser.select([:name, :id]).all : non_ir_advs
    @list += (non_custom_advs.blank?) ? CustomAdvertiser.select([:name, :id]).all : non_custom_advs
    @list = @list.sort_by &:name
  end

  def save_high_resolution_image
    advertiser_splitted = params[:advertiser_id_with_class_name].split('.')
    advertiser_class = advertiser_splitted[0].classify.constantize
    advertiser_id = advertiser_splitted[1].to_i
    @advertiser = advertiser_class.find_by_id(advertiser_id)
    @advertiser.image = params[advertiser_splitted[0].underscore.downcase.to_sym][:image]
    @advertiser.save!
    flash[:notice] = "Successfully added !"
    redirect_to admin_hp_stores_path(:type => params[:store_type])
  end


  def create
    if params[:commit] == "Update High Resolution Image"
      advertiser_splitted = params[:advertiser_id_with_class_name].split('.')
      advertiser_class = advertiser_splitted[0].classify.constantize
      advertiser_id = advertiser_splitted[1].to_i
      @advertiser = advertiser_class.find_by_id(advertiser_id)
      render "/admins/hp_stores/update_high_resolution_image" and return
    else
      case params[:store_type]
      when "browseable"
        max_count = 8
      when "top_dealers"
        max_count = 16
      when "favorite_stores"
        max_count = 3
      end
      if HpStore.send(params[:store_type]).count >= max_count
        flash[:alert] = "You can't  mark more than #{max_count} merchants"
        redirect_to admin_hp_stores_path(:type => params[:store_type]) and return
      end
      hp_fav_store = HpStore.new
      hp_fav_store.advertiser = params[:advertiser_id_with_class_name]
      hp_fav_store.store_type = params[:store_type]
      if hp_fav_store.save
        flash[:notice] = 'Successfully added.'
      else
        flash[:alert] = hp_fav_store.errors.full_messages
      end
      redirect_to admin_hp_stores_path(:type => params[:store_type])
    end
  end

  def replace_hp_store
    hp_fav_advertiser = HpStore.find_by_id_and_store_type(params[:hp_adv_id], params[:store_type])
    if hp_fav_advertiser.update_attributes(HpStore.replacing_advertiser(params[:replace_id]))
      flash[:notice] = 'Successfully updated.'
    else
      flash[:alert] = hp_fav_advertiser.errors.full_messages
    end
    redirect_to admin_hp_stores_path(:type => params[:store_type])
  end

  def destroy
    @store = HpStore.find_by_id_and_store_type(params[:id], params[:type])
    if @store.destroy
      flash[:notice] = 'Successfully deleted.'
    else
      flash[:alert] = 'Something went wrong, please try again.'
    end
    redirect_to admin_hp_stores_path(:type => params[:type])
  end

  def add_custom_store_logo
    if params[:store_type] == "top_dealers" or params[:store_type] == "browseable"
      if params[:adv_type] == "CustomAdvertiser"
        @advertiser = params[:adv_type].constantize.where("id = (?)", params[:adv_id]).first
      else
        @advertiser = params[:adv_type].constantize.where("advertiser_id = (?)", params[:adv_id]).first
      end
      @advertiser_store_image = @advertiser.build_hp_advertiser_image()
      @advertiser_store_image.save!
      render :action => "edit_custom_store_logo"
    end
  end

  def edit_custom_store_logo
    @advertiser_store_image = HpAdvertiserImage.find(params[:hpai])
  end

  def create_custom_store_logo
    if params[:adv_type] == "CustomAdvertiser"
      @advertiser = params[:adv_type].constantize.where("id = (?)", params[:adv_id]).first
    else
      @advertiser = params[:adv_type].constantize.where("advertiser_id = (?)", params[:adv_id]).first
    end
    @advertiser_store_image = @advertiser.build_hp_advertiser_image(params[:hp_advertiser_image])
    if @advertiser_store_image.save
      flash[:notice] = "Store Image added"
    else
      flash[:alert] = @advertiser_store_image.errors.full_messages
    end
    redirect_to admin_hp_stores_path(:type => params[:store_type])
  end

  def update_custom_store_logo
    @advertiser_store_image = HpAdvertiserImage.find(params[:id])
    if @advertiser_store_image.update_attributes(hp_advertiser_image_params)
      flash[:notice] = "Store Image updated"
    else
      flash[:alert] = @advertiser_store_image.errors.full_messages
    end
    redirect_to admin_hp_stores_path(:type => params[:store_type])
  end
  
  private
  
      
  def hp_advertiser_image_params
    params.require(:hp_advertiser_image).permit(:title, :description, :hp_image)
  end


end
