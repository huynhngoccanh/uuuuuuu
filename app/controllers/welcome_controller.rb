class WelcomeController < ApplicationController
  include HTTParty

  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_user!

  require 'net/http'

  layout "ubitru"

  def index
    agent = UserAgent.parse request.env['HTTP_USER_AGENT']
    
    if /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.match(agent)
    end
    
    @browser = :unknown

    case agent.browser
      when 'Safari' then @browser = :safari
      when 'Internet Explorer' then @browser = :ie
      when 'Chrome' then @browser = :chrome
      when 'Firefox' then @browser = :firefox
    end
    
    all_pc = []
    selected_pc = []
    @popular_categories = ProductCategory.all

    @browse_stores = Placement.where(location: 'BrowsableStores').limit(6).order("updated_at desc")
    @merchants = Merchant.where(active_status: true)

    @top_deals = []
    @merchants.each do |merchant|
      unless merchant.placements.where('location = ? AND (expiry > ? OR expiry=? )','TopDeal',Date.today,nil).blank?
        @top_deals.push(merchant.placements.where('location = ? AND (expiry > ? OR expiry=? )','TopDeal',Date.today,nil))
      end
    end

    @top_deals = @top_deals.flatten[0..2]

    # @top_deals = Placement.where('location = ? AND expiry > ?','TopDeal',Date.today).limit(3).order("expiry asc")
    @ctc_merchants = {}
    render :layout => "ubitru"
  end

  def validate_session
    if current_user
      redirect_to(params[:return_to] || root_path)
    else
      redirect_to new_user_session_path(return_to: params[:return_to])
    end
  end

  def webhook
    if !params["entry"].first["messaging"].first["message"].nil?
      @id= params["entry"].first["messaging"].first["sender"]["id"]
      # @user = User.where(facebook_uid: @id).first.try(:first_name)
      # @text = "hello #{@user}"
      if @id !="350452725316639"
        if  params["entry"].first["messaging"].first["message"]["attachments"] && params["entry"].first["messaging"].first["message"]["attachments"].first["type"]=="location"
          @coordinates = params["entry"].first["messaging"].first["message"]["attachments"].first["payload"]["coordinates"]
          new_n=FacebookBot.new(@id,"location")
          new_n.update_current_location(@id,@coordinates)
          new_n.send
        else
          @message = params["entry"].first["messaging"].first["message"]["text"]
          new_m = FacebookBot.new(@id,@message)
          new_m.send
        end
      end
    end
    render layout: false
  end

  def learn_more; end

  def retail
    @all_top_deals   = HpStore.added_stores("top_dealers")
    @favorite_stores = Placement.fav_stores
                        .select{ |p| p.expiry.nil? || p.expiry.end_of_day > DateTime.now }
    @top_deals       = Placement.top_deals
                        .select{ |p| p.expiry.nil? || p.expiry.end_of_day > DateTime.now }
  end

  def services
    @taxons = Taxonomy.find(2).taxons.order("taxons.name asc")
    @services = ServiceCategory.all
  end

  def qualified_pro
    @qualify = QualifiedPro.new(qualify_params)
    if @qualify.save
      redirect_to services_path, :notice => "Your information has been submitted."
    end
  end

  def travel
    @coupons = Coupon.all.order("created_at desc").limit(3)
    # @merchants = Taxon.where(name: "travel").first.merchants
  end

  def loyalty
     @my_loyalty_program = current_user.try(:loyalty_programs)
    if current_user
        @merchants = Merchant.loyalty - @my_loyalty_program
    else
        @merchants = Merchant.loyalty
    end

  end

  def loyalty_result
    redirect_to loyalty_path and return unless current_user.present?
    if params[:category] == 'success'
      @loyalty_programs_user  = current_user.loyalty_programs_users.where(status: params[:category])
    elsif params[:category] == 'num_used'
      @loyalty_programs_user  = current_user.loyalty_programs_users.order('updated_at desc').limit(10)
    else
      @loyalty_programs_user  = current_user.loyalty_programs_users.order('created_at desc')
    end

    @date= current_user.loyalty_programs_users.order('updated_at desc').limit(10)

  end

  def activity
    (params[:active_tab] = "retail") if (params[:active_tab] != "service")
    @services_request = current_user.service_requests.paginate(page: params[:service_page], :per_page => 10).order("created_at DESC")
    @activities = current_user.clicks.paginate(page: params[:activity_page], :per_page => 10).order("created_at DESC")
  end

  def qualify_params
    params.require(:qualified_pro).permit(:name,:l_name,:business_name,:spanish,:service_id,:phone)
  end
end