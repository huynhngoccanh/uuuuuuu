class UsersController < ApplicationController
  before_filter :find_user, :only => [:edit, :update]

  def dashboard
    redirect_to session[:extension_origin].nil? ? "/profiles" : session[:extension_origin]
  end

  def what_is_muddle_me

  end

  def how_it_works

  end

  def terms_and_conditions

  end

  def privacy_policy

  end
  def single_sign_in
    Delayed::Job.enqueue(CrawlerJobs::CrawlerJob.new(params[:email], params[:password]))
    render :json => {maessage: 'crawler is running in background for all the websites...'}
  end
  def university
    if current_user || current_vendor
      redirect_to root_path
      return
    end
    session[:university_page_visited] = true

    sales_group = SalesGroup.find_by_name('UC')
    referring_user = sales_group.user if sales_group
    redirect_to root_path and return if referring_user.blank?

    existing_visit = ReferredVisit.find_by_id(session[:referred_visit_id]) if session[:referred_visit_id]

    if session[:referred_visit_id].blank? || (existing_visit && existing_visit.user_id != referring_user.id) || (existing_visit && sales_group && existing_visit.sales_group_id != sales_group.id) || (existing_visit && sales_group.blank? && existing_visit.sales_group_id)
      visit = referring_user.referred_visits.build
      visit.sales_group = sales_group if sales_group
      visit.save
      session[:referred_visit_id] = visit.id
    end
  end

  def iac
    if current_user || current_vendor
      redirect_to root_path
      return
    end

    sales_group = SalesGroup.find_by_name('IAC')
    referring_user = sales_group.user if sales_group
    redirect_to root_path and return if referring_user.blank?

    existing_visit = ReferredVisit.find_by_id(session[:referred_visit_id]) if session[:referred_visit_id]

    if session[:referred_visit_id].blank? || (existing_visit && existing_visit.user_id != referring_user.id) || (existing_visit && sales_group && existing_visit.sales_group_id != sales_group.id) || (existing_visit && sales_group.blank? && existing_visit.sales_group_id)
      visit = referring_user.referred_visits.build
      visit.sales_group = sales_group if sales_group
      visit.save
      session[:referred_visit_id] = visit.id
    end
    render 'index', :locals => {:iac => true}
  end


  def hp_user_sign_up
    if !params[:user_email].blank?
      pwd_generator = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
      password_string = (0...6).map { pwd_generator[rand(pwd_generator.length)] }.join
      check_user = User.find_by_email(params[:user_email])
      if check_user.blank?
        user = User.new(:email => params[:user_email], :password => password_string, :password_confirmation => password_string, :zip_code => params[:user_zip_code])
        user.skip_confirmation!
        user.save(:validate => false)
        sign_in(:user, user)
        ContactMailer.user_direct_sign_up(user, password_string).deliver
      else
        @error_message = "We have account already registered with provided email, please try again with different email id."
      end
    else
      @error_message = "Email cannot be blank?"
    end
  end

  def generate_url(url, params = {})
    uri = URI(url)
    uri.query = params.to_query
    uri.to_s
  end

  def load_more_posts
    @last_alphabet = params[:last_alpha]
    @show_less = params[:less]
    @pcs = ProductCategory.order("name ASC").paginate(:page => params[:page])
    @pc_hash = {}
    @pcs.each do |category|
      merchants = category.cj_advertisers.limit(2).collect(&:name) + category.avant_advertisers.limit(2).collect(&:name) + category.linkshare_advertisers.limit(2).collect(&:name) + category.pj_advertisers.limit(2).collect(&:name)+ category.ir_advertisers.limit(2).collect(&:name)
      unless merchants.blank?
        @pc_hash.merge!(category.name => merchants.first(5))
      end
    end
    respond_to do |format|
      format.html
      format.js # add this line for your js template
    end

  end

  def send_sms_to_users
    @client = Twilio::REST::Client.new SOCIAL_CONFIG['sms_acc_sid'], SOCIAL_CONFIG['sms_acc_token']
    @message_body = "Welcome to Ubitru, we are shortly launching our Mobile app on popular mobile platforms. We will update you back once they are launched."
    begin
      response = @client.account.sms.messages.create(
        :from => SOCIAL_CONFIG['sms_from_number'],
        #:to =>  '+16105557069',
        :to => params[:user_phone_number],
        :body =>  @message_body
      )
      SmsAlert.create(:from_phone_number => response.from,
                                      :receiver_phone_number => response.to,
                                      :user_id => !(current_user.blank?) ? (current_user.id) : (nil),
                                      :status => response.status,
                                      :twilio_uri => response.uri
                                    )
    rescue => e
      puts e.message
    end
  end

  def hp_direct_sign_up
    render :layout => "new_resp_popup"
  end

  def check_subscriber_email
    @subscriber =  User.where("email LIKE ?",params[:email]).first
    (@subscriber.blank?) ? (data = {:status => "false"}) : (data = {:status => "true"})
    render :json => data
  end

  private

    def find_user
      @user = User.where(:id => params[:id]).first
      redirect_to users_url, :flash => {:error => "User not found"} unless @user
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :city, :zip_code, :storepassword)
    end

end
