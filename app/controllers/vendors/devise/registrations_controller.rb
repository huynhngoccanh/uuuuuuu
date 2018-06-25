class Vendors::Devise::RegistrationsController < Devise::RegistrationsController

  def new
    session[:vendor] = params[:vendor]
    redirect_to :action => "step1"
  end

  def original
    session[:vendor_tranfer_amount] = 15
    redirect_to :action => :new
  end

  def premium
    session[:vendor_tranfer_amount] = 25
    redirect_to :action => :new
  end

  def step1
    session[:vendor] ||= {}
    session[:vendor].merge!(params[:vendor]) if  params[:vendor]
    resource = build_resource(session[:vendor])
    current_admin ? resource.create_by_admin = true : resource.create_by_admin = false
    if request.post?
      resource.valid?
      step1_fields = ['company_name', 'email', 'password', 'first_name', 'last_name', 'address', 'city', 'zip_code', 'phone', 'website_url', 'review_url', 'terms']
      if (step1_fields & resource.errors.messages.keys.map{|e| e.to_s}.uniq).empty?
        redirect_to :action => "step2"
      else
        render :action => "step1"
      end
    end
  end

  def step2
    session[:vendor].merge!(params[:vendor])  if  params[:vendor]
    resource = build_resource(session[:vendor])
    @categories = ServiceCategory.all
    current_admin ? resource.create_by_admin = true : resource.create_by_admin = false
    if request.post?
      resource.dont_require_password_confirmation = true if resource.create_by_admin
      resource.valid?
      step2_fields = ['service_provider', 'service_provider_keywords', 'retailer', 'retailer_keywords']
      if (step2_fields & resource.errors.messages.keys.map{|e| e.to_s}.uniq).empty?
        resource.skip_confirmation! if resource.create_by_admin
        if resource.save
          if resource.create_by_admin
            redirect_to admin_vendors_path, :notice => "Vendor was created successfully."
          elsif resource.active_for_authentication?
            set_flash_message :notice, :signed_up if is_navigational_format?
            sign_in(resource_name, resource)
            redirect_to after_sign_up_path_for(resource)
          else
            set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
            expire_session_data_after_sign_in!
            redirect_to after_inactive_sign_up_path_for(resource)
          end
        else
          clean_up_passwords resource
          flash[:alert] = "Something went wrong. Please, try again."
          render :action => "step1"
        end
      else
        render :action => "step2"
      end
    end
  end

  def after_sign_up_path_for(resource_name)
    if session[:vendor_tranfer_amount].nil?
      root_path
    else
      funds_transfers_path
    end
  end

end
