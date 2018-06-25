class Admins::AddStorecatToMerchantController < Admins::ApplicationController
  def index    
    @cat_list = Admins::StoreCategory.select([:name,:id]).all
    
    #abort(@t.inspect)
  end
  
  def get_merchants_list
    @list = CjAdvertiser.select([:name,:id,1]).all 
    @list += PjAdvertiser.select([:name,:id,2]).all
    @list += AvantAdvertiser.select([:name,:id,3]).all
    @list += LinkshareAdvertiser.select([:name,:id,4]).all
    @list += IrAdvertiser.select([:name,:id,5]).all
    @list = @list.sort_by &:name
    render :json=> @list
  end
  
  def get_selected_merchants_list
    @cat_id = params[:cat_id];
    @list =AddStoreToMerchant.where("store_cat_id=?",@cat_id).all
    @names = Array.new()
    @count = 0
    @list.each do |l|
      if l.advertiser_type=="Ir" then
          @name =  IrAdvertiser.select([:name]).where(["id= ?", l.advertiser_id ]).all
      end
      if l.advertiser_type=="Cj" then
          @name = CjAdvertiser.select([:name]).where(["id= ?", l.advertiser_id ]).all
      end
      if l.advertiser_type=="Pj" then
          @name = PjAdvertiser.select([:name]).where(["id= ?", l.advertiser_id ]).all
      end
      if l.advertiser_type=="Linkshare" then
          @name = PjAdvertiser.select([:name]).where(["id= ?", l.advertiser_id ]).all
      end
      if l.advertiser_type=="Avant" then
          @name = AvantAdvertiser.select([:name]).where(["id= ?", l.advertiser_id ]).all
      end
      @name << l.id
      @names[@count] = @name
      @count +=1
    end
   # abort(@names.inspect)
    render :json=> @names
    #render :text => "Table will be appear here"
  end
  
  def add_merchant
    @store_cat_id = params[:cat_id];
    @advertiser_id = params[:merchant_id];
    @advertiser_type = params[:merchant_type];
    @insert = Admins::AddStoreToMerchant.create(:store_cat_id=> @store_cat_id, :advertiser_id=>@advertiser_id,:advertiser_type=>@advertiser_type)
    if @insert.save
      render :text=> "Merchent Added successfully"
    else
      render :text=> "Merchent already added"
    end
    
  end
  
  def remove_selected_merchant
    @id = params[:id];
    @del = AddStoreToMerchant.destroy(@id)
    render :text=> "Merchant Removed"
  end
  
end
