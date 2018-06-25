class MerchantsController < ApplicationController

  def index
    @merchant = Merchant.where(slug: params[:slug],active_status: true).last
    @merchant.increment!(:view_counter)
    @user_coupons = []
    @coupons = @merchant.coupons.where("coupons.expires_at >= ?", Date.today).order("created_at desc")
    render :layout => "ubitru"
  end

  def coupons
  	@merchant = Merchant.where(slug: params[:slug], active_status: true).last

    if @merchant
      @merchant.update(lastseen: Date.today)
      @merchant.increment!(:view_counter)

    	@user_coupons = []
      @coupons_co = @merchant.coupons.all.order("created_at desc")

      if params[:q] && params[:q][:filter]
        if params[:q][:filter] == "Popularity"
          @coupons = @merchant.coupons.all.order("views desc").where("expires_at > ? OR expires_at IS ?", Date.today, nil).paginate(:page => params[:page], :per_page => 30).order("header asc")
        elsif
          @coupons = @merchant.coupons.all.order("expires_at asc").where("expires_at > ? OR expires_at IS ?", Date.today, nil).paginate(:page => params[:page], :per_page => 30).order("header asc")
        end
      else
        if params[:coupon_type]=='coupon'
    	    @coupons_all = @merchant.coupons.where.not(verified_at: nil ).order("created_at desc")
          @coupons = @merchant.coupons.where(:code=> [nil,""])
        elsif params[:coupon_type] == 'code'
          @coupons = @merchant.coupons.where.not(:code=>[nil,''])
        else
          @coupons = @merchant.coupons.all.order("created_at desc").where("expires_at > ? OR expires_at IS ?", Date.today, nil).paginate(:page => params[:page], :per_page => 30).order("header asc")
        end
      end
      render :layout => "ubitru"
    else
      redirect_to :back ,:notice=>"!"

    end
  end


  def redirect
  	@merchant = Merchant.where(id: params[:id]).first
    @click = @merchant.clicks.build(ip: request.ip)
    @click.save
    unless params[:access_token].blank?
      @user = ApiKey.where(access_token: params[:access_token], expire:true).first.try(:user)
      @click.update_attributes(user_id: @user.id)
    end
    redirect_to @click.url
  end

end