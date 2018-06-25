class Vendors::SettingsController < ApplicationController
  before_filter :authenticate_vendor!


  def new
    unless current_vendor.vendor_setting.nil?
      redirect_to :action=>:edit
      return
    end
    @vendor_setting = current_vendor.build_vendor_setting(
        :recommended_auctions_mail => current_vendor.recommended_auctions_mail?,
        :auction_status_mail => current_vendor.auction_status_mail?,
        :auction_result_mail => current_vendor.auction_result_mail?,
        :contact_info_mail => current_vendor.contact_info_mail?,
        :auto_bid_mail => current_vendor.auto_bid_mail?
    )
  end

  def edit
    if current_vendor.vendor_setting.nil?
      redirect_to :action=>:new
      return
    end
    @vendor_setting = current_vendor.vendor_setting
    render :action => "new"
  end


  def create
    @vendor_setting = current_vendor.build_vendor_setting(params[:vendor_setting])

    if @vendor_setting.save
      redirect_to url_for(:controller=>'vendors/profile', :action=>'show'), :notice => 'Your settings were successfully saved.'
    else
      render :action => "new"
    end
  end

  def update
    @vendor_setting = current_vendor.vendor_setting

    if @vendor_setting.update_attributes(params[:vendor_setting])
      redirect_to url_for(:controller=>'vendors/profile', :action=>'show'), :notice => 'Your settings were successfully updated.'
    else
      render :action => "new"
    end
  end

end