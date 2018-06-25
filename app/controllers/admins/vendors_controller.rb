class Admins::VendorsController < Admins::ApplicationController

  def index
    list
  end

  def show
    @vendor = Vendor.find(params[:id])
    list_transfers_and_refunds(@vendor)
    @funds_grant = @vendor.fund_grants.build
  end

  def block
    @vendor = Vendor.find(params[:id])
    respond_to do |format|
      if @vendor.update_attribute :blocked, true
        format.html { redirect_to admin_vendors_path, :notice => "Vendor was blocked successfully." }
      else
        format.html { redirect_to admin_vendors_path, :alert => "Unable to block vendor." }
      end
    end
  end

  def unblock
    @vendor = Vendor.find(params[:id])
    respond_to do |format|
      if @vendor.update_attribute :blocked, false
        format.html { redirect_to admin_vendors_path, :notice => "Vendor was unblocked successfully." }
      else
        format.html { redirect_to admin_vendors_path, :alert => "Unable to unblock vendor." }
      end
    end
  end

  def create_funds_grant
    @vendor = Vendor.find(params[:id])
    @funds_grant = @vendor.fund_grants.create(params[:vendor_funds_grant])
    if @funds_grant.save
      redirect_to url_for(:action=> 'show'), :notice => "Successfully granted $#{@funds_grant.amount} to vendor."
    else
      list_transfers_and_refunds(@vendor)
      render :action => 'show'
    end
  end


  private

  def list types=[:all], per_page=10
    sort_by = ['id', 'company_name', 'first_name', 'last_name', 'email', 'address', 'city', 'zip_code', 'type']

    types.each do |type|
      params[:"#{type}_order"] = 'id' if params[:"#{type}_order"].blank?
      dir = instance_variable_set "@#{type}_dir", :DESC
      if params[:"#{type}_order"] && sort_by.include?(params[:"#{type}_order"])
        instance_variable_set "@#{type}_order", params[:"#{type}_order"]
        instance_variable_set "@#{type}_order_str", 'vendors.id' if params[:"#{type}_order"] == 'id'
        instance_variable_set "@#{type}_order_str", '!service_provider, !retailer' if params[:"#{type}_order"] == 'type'
      end
      ord = instance_variable_get "@#{type}_order"
      ord_str = instance_variable_get "@#{type}_order_str"
      dir = instance_variable_set "@#{type}_dir", params[:"#{type}_dir"] == 'DESC' ? :DESC : :ASC unless params[:"#{type}_dir"].blank?

      list = Vendor

      list = list.search(params[:search]) unless params[:search].blank?

      list = list.order("#{ord_str || ord} #{dir}").paginate(:page=>params[:"#{type}_page"], :per_page=>per_page)
      instance_variable_set("@vendors_#{type}", list)
    end
  end

end
