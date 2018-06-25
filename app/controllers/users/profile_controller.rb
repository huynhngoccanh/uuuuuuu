class Users::ProfileController < ApplicationController
  before_filter :authenticate_user!
  layout 'ubitru'

  def show
  end

  def update
    @user = User.find(current_user.id)
    if @user.update_without_password(user_params)
      redirect_to profile_url, :notice => 'Profile was successfully updated.'
    else
      render :action => "edit"
    end
  end


  def edit
    @user = User.find(current_user.id)
  end

  def contact_info
  end

  def earning_info
    @transaction = current_user.payment_histories.all.paginate(:page => params[:page], :per_page => 5).order("created_at desc")
    if current_user
      @merchants = Merchant.loyalty.paginate :page => params[:page], :per_page => 5
    end
  end
  
  def notification
    if find_notification
      @notification = current_user.user_setting
    else
      @notification = UserSetting.create(user_id: current_user.id)
    end
  end

  def find_notification
    !current_user.user_setting.nil?
  end

  def update_notification
    if current_user.user_setting.update_attributes(user_noti_params)
        redirect_to "/profile/notification", :success => 'User notification setting was successfully updated.'
      else
        redirect_to notification_profile_path, :notice => 'Opps! Notification Setting Not updated, Please try later.'
      end
  end


  def invite_friends
  end

  def contact_us
  end

  def update_contact_info
    @user = current_user
    @user.dont_require_password = true if params[:user][:password].nil?
    if @user.update_attributes(params[:user])
      sign_in @user, :bypass => true
      redirect_to contact_info_profile_url, :notice => 'User setting info was successfully updated.'
    else
      render :action => "contact_info"
    end
  end

  def update_password
    @user = current_user
    if @user.update_with_password(params[:user])
      sign_in(@user, :bypass => true)
      redirect_to contact_info_profile_url, :notice => "Password has been successfully updated."
    else
      render :action => "contact_info"
    end

  end

  def submit_coupon
    @advertiser = params[:advertiser_type].constantize.where("id =?", params[:advertiser_id]).first if params[:advertiser_type].present? && params[:advertiser_id].present?
    @store_link = get_store_link(@advertiser, params[:advertiser_type])
    @user_coupon = @advertiser.user_coupons.new if @advertiser.present?
    @user_coupon = UserCoupon.new if @user_coupon.blank?
    render :layout => 'new_resp_popup'
  end

  def save_coupon
    @status = false
    @message = ''
    spam_status = UserCoupon.check_spam_in_discount_description(params[:discount_description])
    if !spam_status
      if params[:printable_coupon].present?
        @user_coupon = UserCoupon.new(
          :user_id => current_user.id,
          :advertisable_id => params[:advertisable_id],
          :advertisable_type => params[:advertisable_type],
          :expiration_date => params[:expiration_date],
          :store_website => params[:store_website],
          :offer_type => "Printable Coupon",
          :admin_approve => false
        )
        if @user_coupon.save
          PrintableCoupon.create!(:user_coupon_id => @user_coupon.id, :coupon_image => params[:printable_coupon])
          @status = true
          @message = 'Coupon was successfully added'
          redirect_to :root
          return
        else
          @message = 'Coupon was not added. Please try again'
        end
      else
        @user_coupon = UserCoupon.new(
          :user_id => current_user.id,
          :advertisable_id => params[:advertisable_id],
          :advertisable_type => params[:advertisable_type],
          :code => params[:code],
          :discount_description => params[:discount_description],
          :expiration_date => params[:expiration_date],
          :header => params[:header],
          :offer_header => params[:offer_header],
          :store_website => params[:store_website],
          :offer_type => "Coupon code",
          :admin_approve => false
        )
        if @user_coupon.save
          @status = true
          @message = 'Coupon was successfully added'
          redirect_to :root
          return
        else
          @message = 'Coupon was not added. Please try again'
        end
      end
      
    else
      @message = 'The description entered for coupon did not pass spam filter'
    end
    respond_to do |format|
      format.js
      format.html{ render :layout => false }
    end
  end

  def get_store_link(advertiser, advertiser_type)
    store_link = ''
    if advertiser.present? && advertiser_type.present?
      case advertiser_type
        when 'IrAdvertiser' then
          store_link = advertiser.params['AdvertiserUrl'] if advertiser.params.present?
        when 'LinkshareAdvertiser' then
          store_link = advertiser.website
        when 'CjAdvertiser' then
          store_link = advertiser.params['program_url'] if advertiser.params.present?
        when 'AvantAdvertiser' then
          store_link = advertiser.advertiser_url
        when 'PjAdvertiser' then
          store_link = advertiser.params['website'] if advertiser.params.present?
      end
    end
    store_link
  end

  def format_date_from_datepicker(date_str)
    Date::strptime(date_str, "%m/%d/%y") if date_str.present?
  end

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :address, :city, :zip_code, :phone, :storepassword)   
    end
    def user_noti_params
      params.require(:user_setting).permit(:initiated_auction_mail,:ended_auction_mail,:bid_mail)
    end
end
