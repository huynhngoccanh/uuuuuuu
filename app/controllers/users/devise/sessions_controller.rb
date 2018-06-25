class Users::Devise::SessionsController < Devise::SessionsController

  layout "ubitru"

  before_filter :only => "create" do
    sign_out :vendor
    sign_out :admin
  end
  #go to vendor login page if vendor logged in
  before_filter :only => "new" do
    redirect_to :controller=>'vendors/devise/sessions', :action=>'new' unless current_vendor.nil?
    redirect_to :controller=>'admins/devise/sessions', :action=>'new' unless current_admin.nil?
  end

  after_filter :only => "create" do
    set_notifications
    save_user_agent_information
  end

  # =========== Ajax login/logout ===========

  layout "ubitru"

  def new
    if params[:return_to].present?
      self.resource = resource_class.new(sign_in_params)
      store_location_for(resource, params[:return_to])  
    end
    super
  end
  
  def create
    if request.xhr? || request['_xhr']
      resource = warden.authenticate!(:scope => resource_name)
      sign_in_and_render_json(resource_name, resource)
    else
      super
    end
    cookies[:signed_in] = 1
    #Search::ReferralNotificationBoxMessage.create(:message => Search::ReferralNotificationBoxMessage::DEFAULT_MESSAGE.sub('xxx', '$12'), :user_id => resource.id)
  end
  
  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    # set_flash_message! :notice, :signed_out if signed_out
    yield if block_given?
    redirect_to root_url, notice: "Successfully Signed out"
  end

  # def destroy
  #   if request.xhr? || request['_xhr']
  #     sign_out resource_name
  #     redirect_to root_path
  #   else
  #     super
  #   end
  #   cookies.delete(:signed_in)
  #   reset_session
  # end

  def sign_in_and_render_json(resource_or_scope, resource=nil)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    resource ||= resource_or_scope
    sign_in(scope, resource) unless warden.user(scope) == resource
    render :json => {:success => true}
  end
  # =========== End of Ajax login ===========

  protected
  
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end

  private

  def set_notifications
    finished_auctions = current_user.auctions.eager_load(:user).
      where("#{Auction.table_name}.end_time < UTC_TIMESTAMP() AND #{Auction.
      table_name}.end_time > #{User.table_name}.last_sign_in_at").count
    session[:finished_auctions] = finished_auctions if (finished_auctions > 0)
  end

  def save_user_agent_information
    return if current_user.user_agent_logs.count >= UserAgentLog::LOG_COUNT
    current_user.dont_require_password = true

    browser = Browser.new(:accept_language => request.headers["Accept-Language"], :ua => request.headers["User-Agent"])

    UserAgentLog.create(
        :user_id => current_user.id,
        :user_agent => request.headers["User-Agent"],
        :browser_name => browser.name,
        :browser_major_version => browser.version
    )

    logs = current_user.user_agent_logs

    if logs.count == 1
      current_user.update_attributes(:favourite_browser_name=> browser.name, :favourite_browser_major_version=>browser.version)
    else
      frequency = {}

      logs.each do |l|
        frequency["#{l.browser_name} #{l.browser_major_version}"] = (frequency["#{l.browser_name} #{l.browser_major_version}"].nil? ? 1 : frequency["#{l.browser_name} #{l.browser_major_version}"]+1)
      end

      max = 0
      max_name = ""

      frequency.each do |f|
        if f[1] > max
          max = f[1]
          max_name = f[0]
        end
      end

      favourite = current_user.user_agent_logs.where(:browser_name=>current_user.favourite_browser_name, :browser_major_version=>current_user.favourite_browser_major_version).count

      if favourite >= max
        return
      elsif favourite < max
        current_user.update_attributes(:favourite_browser_name=> max_name.split(" ")[0], :favourite_browser_major_version=>max_name.split(" ")[1])
      end

    end
  end

end
