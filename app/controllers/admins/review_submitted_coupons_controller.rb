class Admins::ReviewSubmittedCouponsController < Admins::ApplicationController

  def index
    @user_coupons = UserCoupon.all.paginate(:page => params[:page], :per_page => 20)
  end
  
  def edit
    @user_coupon = UserCoupon.find(params[:id])
  end
  
  def update
    @user_coupon = UserCoupon.find(params[:id])
    if @user_coupon.update_attributes(user_coupons_params)
      redirect_to admins_review_submitted_coupons_path, :notice => 'Coupon Updated Successfully' 
      
    else
      format.html { render :action => "edit" }
      format.json { render :json => @user_coupon.errors, :status => :unprocessable_entity }
    end
    
  end
  
  def destroy
    @user_coupon = UserCoupon.find(params[:id])
    if @user_coupon.destroy
      flash[:notice] = 'Successfully deleted.'
    else
      flash[:alert] = 'Something went wrong, please try again.'
    end
    redirect_to admin_review_submitted_coupons_path
  end
  
  private
  
      
  def user_coupons_params
    params.require(:user_coupon).permit(:id, :code, :discount_description, :header, :offer_header, :expiration_date, :store_website, :admin_approve)
  end


end
