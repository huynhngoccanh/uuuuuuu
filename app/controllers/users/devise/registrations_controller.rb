class Users::Devise::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters 
  # after_filter :only => "create" do
  #   post_to_wall
  # end
  prepend_before_action :require_no_authentication, only: [:new, :create, :cancel]
  prepend_before_action :authenticate_scope!, only: [:edit, :update, :destroy]
  prepend_before_action :set_minimum_password_length, only: [:new, :edit]

  layout "ubitru"
  # GET /resource/sign_up
  def new
    if params[:token] && !InviteUser.where(token: params[:token], status: 'Pending').blank?
      build_resource({})
      yield resource if block_given?
      respond_with resource
    elsif InviteUser.where(token: params[:token], status: 'Active') && params[:token]
      redirect_to root_path , :notice => 'token has been used/expired'
    else
      build_resource({})
      yield resource if block_given?
      if params[:facebook]
        redirect_to new_user_session_path
      else
        respond_with resource
      end
    end

  end
  



  # POST /resource
  def create
    if params[:token] &&  !InviteUser.where(token: params[:token], status: 'Pending').blank?
      
      
      p params[:user][:first_name]
      @referral = InviteUser.where(token: params[:token]).last.update_attributes(:status=>'Active', :name=> params[:user][:first_name], :email=> params[:user][:email] )
    end
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        # set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        # set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        flash.now[:error] = resource.errors.full_messages.join(", ")
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      flash.now[:error] = resource.errors.full_messages.join(", ")
      respond_with resource
    end
  end

  # GET /resource/edit
  def edit
    render :edit
  end

  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      bypass_sign_in resource, scope: resource_name
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  # DELETE /resource
  def destroy
    resource.destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message! :notice, :destroyed
    yield resource if block_given?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    expire_data_after_sign_in!
    redirect_to new_registration_path(resource_name)
  end

  protected

    def update_needs_confirmation?(resource, previous)
      resource.respond_to?(:pending_reconfirmation?) &&
        resource.pending_reconfirmation? &&
        previous != resource.unconfirmed_email
    end

    # By default we want to require a password checks on update.
    # You can overwrite this method in your own RegistrationsController.
    def update_resource(resource, params)
      resource.update_with_password(params)
    end

    # Build a devise resource passing in the session. Useful to move
    # temporary session data to the newly created user.
    def build_resource(hash=nil)
      self.resource = resource_class.new_with_session(hash || {}, session)

    end

    # Signs in a user on sign up. You can overwrite this method in your own
    # RegistrationsController.
    def sign_up(resource_name, resource)
      sign_in(resource_name, resource)
    end

    # The path used after sign up. You need to overwrite this method
    # in your own RegistrationsController.
    def after_sign_up_path_for(resource)
      after_sign_in_path_for(resource)
    end

    # The path used after sign up for inactive accounts. You need to overwrite
    # this method in your own RegistrationsController.
    def after_inactive_sign_up_path_for(resource)
      scope = Devise::Mapping.find_scope!(resource)
      router_name = Devise.mappings[scope].router_name
      context = router_name ? send(router_name) : self
      context.respond_to?(:root_path) ? context.root_path : "/"
    end

    # The default url to be used after updating a resource. You need to overwrite
    # this method in your own RegistrationsController.
    def after_update_path_for(resource)
      signed_in_root_path(resource)
    end

    # Authenticates the current scope and gets the current resource from the session.
    def authenticate_scope!
      send(:"authenticate_#{resource_name}!", force: true)
      self.resource = send(:"current_#{resource_name}")
    end

    def sign_up_params
      devise_parameter_sanitizer.sanitize(:sign_up)
    end

    def account_update_params
      devise_parameter_sanitizer.sanitize(:account_update)
    end

    def translation_scope
      'devise.registrations'
    end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up).push(:first_name, :last_name, :city, :zip_code)
    end
end

# class Users::Devise::RegistrationsController < Devise::RegistrationsController
#   before_filter :configure_permitted_parameters ,  if: :devise_controller?
#   after_filter :only => "create" do
#     post_to_wall
#   end
 

  
#   layout "ubitru"


#   # =========== Ajax sign up ===========
#   def create
#     build_resource(sign_up_params)
#     resource.save
#     yield resource if block_given?
#     if resource.persisted?
#       if resource.active_for_authentication?
#         # set_flash_message! :notice, :signed_up
#         sign_up(resource_name, resource)
#         respond_with resource, location: after_sign_up_path_for(resource)
#       else
#         # set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
#         expire_data_after_sign_in!
#         flash.now[:error] = "User Details Could Not Save, Please try later "
#         respond_with resource, location: after_inactive_sign_up_path_for(resource)
#       end
#     else
#       clean_up_passwords resource
#       set_minimum_password_length
#       flash.now[:error] = "Ooops, Somethings wasn't right. Please Fill All The details carefully....."
#       respond_with resource
#     end
#   end

#   # def create
#   #   build_resource(sign_up_params)

#   #   resource.save
#   #   yield resource if block_given?
#   #   if resource.persisted?
#   #     if resource.active_for_authentication?
#   #       set_flash_message! :notice, :signed_up
#   #       sign_up(resource_name, resource)
#   #       respond_with resource, location: after_sign_up_path_for(resource)
#   #     else
#   #       set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
#   #       expire_data_after_sign_in!
#   #       respond_with resource, location: after_inactive_sign_up_path_for(resource)
#   #     end
#   #   else
#   #     clean_up_passwords resource
#   #     set_minimum_password_length
#   #     respond_with resource
#   #   end
#   # end
#   # # =========== Ajax sign up ===========
  

#   def after_sign_up_path_for(resource_name)
#     if session[:university_page_visited]
#       current_user.update_attribute :from_university_landing_page, true
#     end
#     set_referred_visit
#     root_path
#   end

#   def set_referred_visit
#     if session[:referred_visit_id] && visit = ReferredVisit.find_by_id(session[:referred_visit_id])
#       current_user.referred_visit = visit
#       current_user.save!
#     end
#   end

#   private

#   def post_to_wall
#     post_to_facebook
#     post_to_twitter
#   end

#   def post_to_facebook
#     unless resource.facebook_uid.blank? || resource.facebook_token.blank?
#       begin
#         user = FbGraph::User.new(resource.facebook_uid, :access_token => resource.facebook_token)
#         user.feed!(
#             :message => 'I signed up to MuddleMe. I get the best deals AND make few extra bucks. You should check it out',
#             :link => 'http://muddleme.com',
#             :name => 'MuddleMe',
#             :description => 'MuddleMe'
#         )
#       rescue Exception => e
#         return false
#       end

#     end
#   end

#   def post_to_twitter
#     unless resource.twitter_uid.blank? || resource.twitter_token.blank? || resource.twitter_secret.blank?
#       begin
#         client = Twitter::Client.new(
#             :oauth_token => resource.twitter_token,
#             :oauth_token_secret => resource.twitter_secret
#         )
#         client.update('I signed up to MuddleMe. I get the best deals AND make few extra bucks. You should check it out: muddleme.com')
#       rescue Exception => e
#         return false
#       end
#     end
#   end

#   protected

#   def configure_permitted_parameters
#     devise_parameter_sanitizer.for(:sign_up).push(:first_name, :last_name, :city, :zip_code)
#   end

# end
