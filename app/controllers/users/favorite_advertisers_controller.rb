class Users::FavoriteAdvertisersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @favorite_advertisers = current_user.favorite_advertisers.order('created_at asc')
    non_fav_cj_advs         = FavoriteAdvertiser.non_fav_advertisers(CjAdvertiser.name, current_user)
    non_fav_avant_advs = FavoriteAdvertiser.non_fav_advertisers(AvantAdvertiser.name, current_user)
    non_fav_ls_advs         = FavoriteAdvertiser.non_fav_advertisers(LinkshareAdvertiser.name, current_user)
    non_fav_pj_advs         = FavoriteAdvertiser.non_fav_advertisers(PjAdvertiser.name, current_user)
    non_fav_ir_advs         = FavoriteAdvertiser.non_fav_advertisers(IrAdvertiser.name, current_user)

    @list =   (non_fav_cj_advs.blank?) ? CjAdvertiser.select([:name, :id]).all : non_fav_cj_advs
    @list += (non_fav_avant_advs.blank?) ? AvantAdvertiser.select([:name, :id]).all : non_fav_avant_advs
    @list += (non_fav_ls_advs.blank?) ? LinkshareAdvertiser.select([:name, :id]).all : non_fav_ls_advs
    @list += (non_fav_pj_advs.blank?) ? PjAdvertiser.select([:name, :id]).all : non_fav_pj_advs
    @list += (non_fav_ir_advs.blank?) ? IrAdvertiser.select([:name, :id]).all : non_fav_ir_advs
    @list = @list.sort_by &:name
end

  def create
    if current_user.favorite_advertisers.count > 49
      flash[:alert] = "You can't add more than 50 merchants."
      redirect_to :action => :index and return
    end
    favorite_advertiser = FavoriteAdvertiser.new
    favorite_advertiser.advertiser = params[:advertiser_id_with_class_name]
    favorite_advertiser.user = current_user
    if favorite_advertiser.save
      flash[:notice] = 'Successfully added.'
    else
      flash[:alert] = favorite_advertiser.errors.full_messages
    end
    redirect_to :action => :index
  end

  def destroy
    FavoriteAdvertiser.destroy(params[:id])
    redirect_to :action => :index
  end

  def replace
    fav_advertiser = FavoriteAdvertiser.find_by_id_and_user_id(params[:fav_id], current_user)
    if fav_advertiser.update_attributes(FavoriteAdvertiser.replacing_advertiser(params[:replace_id]))
        flash[:notice] = 'Successfully updated.'
    else
        flash[:alert] = fav_advertiser.errors.full_messages
    end
    redirect_to :action => :index
  end

end
