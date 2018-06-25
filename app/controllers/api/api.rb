class MuddleMeAPI < Grape::API
#  helpers do
#    def current_token; env['api.token']; end
#
#    def current_resource_owner
#      User.find(current_token.resource_owner_id) if current_token
#    end
#  end

  # 500 errors
  rescue_from :all do |error|
    Rack::Response.new([ error.to_s ], 500)
  end

  helpers do
    
    
  ###################################################
  
  
 
   
  def parse_image_data(image_data)
    @tempfile = Tempfile.new('item_image')
    @tempfile.binmode
    @tempfile.write Base64.decode64(image_data[:content])
    @tempfile.rewind

    uploaded_file = ActionDispatch::Http::UploadedFile.new(
      tempfile: @tempfile,
      filename: image_data[:filename]
    )

   uploaded_file.content_type = image_data[:content_type]
    uploaded_file
  end

  def clean_tempfile
    if @tempfile
      @tempfile.close
      @tempfile.unlink
    end
  end
  
  
  ######################################################
    
    def current_user
      #User.where(id: params[:user_id]).first
      resource_owner
    end

    def api_error!(message, code)
      error!({:error => message, :code => code}, code)
    end
    def list_auctions options = {}
      sort_by = ['id','name', 'product_auction', 'max_vendors', 'budget', 'end_time', 'category']

      options = {
        :type=>'in_progress',
        :page=>1,
        :per_page=>30,
        :order_by=>'id',
        :order_dir=>'desc',
      }.merge(options.to_hash.symbolize_keys)

      options[:type] = options[:type].to_sym
      unconfirmed_where_cond = 'auctions.end_time > ? AND ('
      unconfirmed_where_cond += 'auctions.status = "unconfirmed" OR '
      unconfirmed_where_cond += 'auctions.status = "resolved") '
      # unconfirmed_where_cond += 'auctions.status = "resolved" AND '
      # unconfirmed_where_cond += '(cj_offers.id IS NOT NULL OR avant_offers.id IS NOT NULL)))'
      where_conds = {
        :in_progress => 'auctions.end_time >= UTC_TIMESTAMP() ',
        :finished => 'auctions.end_time < UTC_TIMESTAMP() AND status<>"active"',
        :unconfirmed => ['auctions.end_time > ? AND auctions.status = "unconfirmed"', Time.now - Auction::CANT_CONFIRM_AFTER]
      }

      options[:order_by] = 'id' if sort_by.include?(options[:order_by])

      order = case options[:order_by]
      when 'id'
        'auctions.id'
      when 'product_auction'
        '!product_auction'
      when 'category'
        'IF(auctions.product_auction, product_categories.name, service_categories.name)'
      else
        options[:order_by]
      end

      dir = options[:order_dir].downcase == 'asc' ? :ASC : :DESC

      options[:page] = options[:page].to_i
      options[:page] = 1 if options[:page] < 1

      options[:per_page] = options[:per_page].to_i
      options[:per_page] = 30 if options[:per_page] < 1
      options[:per_page] = 100 if options[:per_page] > 100

      list = current_user.auctions.where(where_conds[options[:type]] || where_conds[:in_progress]).
        includes(:service_category, :product_category, {:outcome=>:vendor_outcomes},
          :auction_images, {:bids=>[:vendor, :offer]}, {:winning_bids=>[:vendor, :offer]},
          {:cj_offers=>{:advertiser=>:coupons}}, {:avant_offers=>{:advertiser=>:coupons}}).
        order("#{order} #{dir}").paginate(:page=>options[:page], :per_page=>options[:per_page])
    end

    def format_datetime value
      value && value.strftime('%m/%d/%Y at %R')
    end
  end
  
  desc "Logs user in."
  # params do
  #  requires :login, :type => String, :desc => "User login."
  #  requires :password, :type => String, :desc => "User password."
  # end
  post '/login' do
    params[:user] ||= {}
    user = User.find_for_database_authentication(:email=>params[:user][:email])
    if user && user.valid_password?(params[:user][:password])
      user.generate_new_token = true
      user.to_api_json
    else
      error!({ messages: ["Invalid username/password"] }, :unprocessable_entity)
    end
  end
  
  desc "Logs user out."
  post '/logout' do
#    user = warden.user(:scope => 'user', :run_callbacks => false) # If there is no user
#    warden.raw_session.inspect # Without this inspect here. The session does not clear.
#    warden.logout('user')
#    warden.clear_strategies_cache!(:scope => 'user')
    !!user
  end

  desc "Get current user or oauth data"
  get '/oauthuser' do
    if current_user
      {:user => current_user.to_api_json}
    else
      session = warden.raw_session
      {:oath_data => User.new_with_session({}, session)}
    end
  end

  desc "Check if email is valid"
  get '/email_available' do
    error!("email param not present in reuqest", 400) if params[:email].blank?
    User.find_by_email(params[:email]).blank?
  end

  desc "Get help and contact html"
  get '/help_and_contact_html' do
    setting = SystemSettings.find_by_name('mobile_help_content')
    return {:html=>''} if setting.blank?
    {:html=>setting.value}
  end

  desc "Get current user"
  oauth2
  get '/user' do
    current_user.to_api_json
  end

  desc "Update user attributes"
  oauth2
  put '/user' do
    user = current_user
    params[:user] ||= {}
    params[:user].delete :password
    user.dont_require_password = true
    if user.update_attributes(params[:user])
      warden.session_serializer.store(user, :user)
      current_user.to_api_json
    else
      error!(user.errors.to_a, 400)
    end
  end

  desc "Register user"
  post '/user' do
    
   
    
#    if current_user
#     
#      user = warden.user(:scope => 'user', :run_callbacks => false) # If there is no user
#      warden.raw_session.inspect # Without this inspect here. The session does not clear.
#      warden.logout('user')
#      warden.clear_strategies_cache!(:scope => 'user')
#    end
 
    hash ||= params[:user] || {}
  #  session = warden.raw_session
  #  user = User.new_with_session hash, session
    user=User.new(:first_name=>params[:user][:first_name],:email=>params[:user][:email],:password=>params[:user][:password],
                :phone=>params[:user][:phone] )
    a=[]
    a=user.first_name.split(' ', 2)
    if !a[1].nil?
     
      user.first_name=a[0]
      user.last_name=a[1]
    else
  
      user.dont_require_last_name=true
    end
    user.dont_require_password_confirmation = true
    user.dont_require_zipcode = true
    user.generate_new_token = true
    if user.save
   #   warden.session_serializer.store(user, :user)
      user.to_api_json
    else
      error!(user.errors.to_a, 400)
    end
  end

  desc "auctions list"
  # params do
  #   optional :type
  #   optional :page
  #   optional :per_page
  #   optional :order_by
  #   optional :order_dir
  # end
  oauth2
  get '/auctions' do
    list = list_auctions params
    {
      :auctions => list.map(&:to_api_json),
      :total_items => list.total_entries,
      :page => list.current_page
    }
  end

  desc "auction details"
  oauth2
  get '/auction/:id' do
    auction = current_user.auctions.find(params[:id])
    auction.to_api_json
  end

  desc "create auction"
  oauth2
  post '/auctions' do
    params[:auction] ||= {}
    images = params[:auction].delete(:auction_images) || []

   # auction = current_user.auctions.build params[:auction]
   auction = current_user.auctions.build params[:auction]
    auction.from_mobile = true

    error!(auction.errors.to_a, 400) if !auction.save
    auction.delay_fetch_affiliate_offers
    
    images.each do |img|
      error!('No image data for auction image', 400) if img[:image].blank?
      error!('Image file name cannot be blank', 400) if img[:file_name].blank?
      stream = StringIO.new(Base64.decode64(img[:image]))
      #auction_image = current_user.auction_images.build :auction => auction
      auction_image = current_user.auction_images.build :auction => auction
      auction_image.image = stream
      auction_image.image.instance_write(:content_type, img[:content_type])
      auction_image.image.instance_write(:file_name, img[:file_name])
      error!(auction_image.errors.to_a, 400) if !auction_image.save
    end

    auction.to_api_json
  end

  desc "provide auction outcome"
  #params
  # :outcome=>{
  #   :purchase_made=>true/false
  #   :vendor_id=>vendor_id
  #   :comment=> (optional)
  # }
  oauth2
  post "/auction/:id/outcome" do
    #auction = current_user.auctions.find(params[:id])
    auction = current_user.auctions.find(params[:id])
    if auction.outcome.nil? || auction.status != 'unconfirmed'
      error!('This auction is unconfirmable', 403)
      return
    end
    params[:outcome] ||={}

    outcome = auction.outcome
    vendor_id = params[:outcome].delete :vendor_id
    outcome.attributes = params[:outcome]
    if outcome.purchase_made
      begin
      outcome.vendor_ids = (outcome.vendor_ids + vendor_id.to_a).uniq
      rescue ActiveRecord::RecordInvalid
        error!('Validatin errors: ' + outcome.vendor_outcomes.first.errors.to_a.join(' '), 400)
      end
    end
    outcome.confirmed_at = Time.now

    if outcome.save
      if outcome.auction.errors[:status].blank?
        vendor_outcome = outcome.vendor_outcomes.where('accepted IS NULL').first
        unless vendor_outcome.nil?
          if vendor_outcome.auto_accepted
            vendor_outcome.update_attribute :accepted, true
          else
            AuctionsMailer.delay.vendor_confirm_outcome(auction, vendor_outcome.vendor) if EmailContent.vendor_confirm_outcome_mail?
          end
        end
        Admins::AuctionsMailer.delay.user_provide_auction_outcome(auction, outcome) unless outcome.comment.blank? #send mail to support only if comment is not blank
        auction.reload.to_api_json
      else
        alert = "The deadline for confirming the outcome of this auction"
        alert += " expired #{format_datetime(auction.end_time + Auction::CANT_CONFIRM_AFTER)}"
        error!(alert, 403)
      end
    else
      error!('Validatin errors: ' + outcome.errors.to_a.join(' '), 400)
    end
  end

  desc "rsolve auction"
  oauth2
  get "/auction/:id/resolve" do
    #auction = current_user.auctions.find(params[:id])
    auction = current_user.auctions.find(params[:id])

    auction.resolve_auction true
    auction.to_api_json
  end

  desc "coupons for offer"
  oauth2
  get "/offer_coupons/:type/:offer_id" do
    if !['cj','avant', 'pj', 'ir', 'linkshare'].include?(params[:type])
         error!("Invalid type must be 'cj' or 'avant'or 'pj' or 'ir' or 'linkshare'", 400)
    else
      #offer = current_user.send("#{params[:type]}_offers").find(params[:offer_id])
      offer = current_user.send("#{params[:type]}_offers").find(params[:offer_id])
      offer.advertiser.coupons.map(&:to_api_json)
    end
  end
  
  desc "coupons for loyalty program"
  oauth2
  get "/loyalty_programs/:id/coupons" do
    loyalty_program = LoyaltyProgram.find(params[:id])
    coupons={}
  #  coupons[:affiliate_coupons]=loyalty_program.affiliate_coupons.last(6).as_json
    coupons[:affiliate_coupons]=loyalty_program.affiliate_coupons.last(6).as_json
    coupons[:loyalty_program_coupons]=loyalty_program.loyalty_program_coupons.last(6)
    coupons
  end
  
#
#  desc "coupons for loyalty program"
#  oauth2
#  get "/loyalty_programs/:id/coupons" do
#    loyalty_program = LoyaltyProgram.find(params[:id])
#    loyalty_program.coupons.as_json
# 
#  end
  
  desc "offers for loyalty program"
  oauth2
  get "/loyalty_programs/:id/offers" do
    loyalty_program = LoyaltyProgram.find(params[:id])
    loyalty_program.offers.as_json
 
  end
  
   
  desc "offers for loyalty program"
  oauth2
  get "/loyalty_programs/:id/affiliates_offers" do
    loyalty_program = LoyaltyProgram.find(params[:id])
    loyalty_program.affiliates_offers.as_json
 
  end
    
  desc "personal offers for loyalty program"
  oauth2
  get "/loyalty_programs/:id/personal_offers" do
    loyalty_program = LoyaltyProgram.find(params[:id])
    loyalty_program.personal_offers.as_json(methods: [:offer_video_url, :barcode_image_url, :offer_images_url], except: [:offer_video_file_name,:offer_video_content_type, :offer_video_updated_at, :barcode_image_file_name, :barcode_image_content_type, :barcode_image_file_size, :barcode_image_updated_at, :product_offer, :service_type, :created_at, :updated_at, :is_deleted, :coupon_code, :total_spent, :offer_url, :vendor_id])
 
  end
  
  
  desc "funds_withdrawal"
  oauth2
  post "/funds_withdrawal" do
     @withdrawal, success_message, error_message = current_user.withdraw_funds(params[:funds_withdrawal])
    if error_message
      error!(error_message, 400)
    elsif @withdrawal
      @withdrawal
    else
      {success: success_message}
    end    
  end
  
    
  desc "users loyalty programs"
  oauth2
  get "loyalty_programs/users" do
    loyalty_programs_users={}
    LoyaltyProgram.all.each do |loyalty_program|
      if LoyaltyProgramsUser.where(loyalty_program_id: loyalty_program.id).exists?
        loyalty_programs_users[loyalty_program.name]=LoyaltyProgramsUser.where(loyalty_program_id: loyalty_program.id).as_json
      end
    end
    
    loyalty_programs_users
  end
  
  desc "search"
  oauth2
  get "search_all" do
    if params[:keyword]
        
#        search_result={}
        
#        if LoyaltyProgramOffer.where(offer_description: params[:keyword]).exists?
#             search_result[:loyalty_program_offers]=LoyaltyProgramOffer.where(offer_description: params[:keyword])
#        end
#        
#        if LoyaltyProgramCoupon.where(description: params[:keyword]).exists?
#             search_result[:loyalty_program_coupons]=LoyaltyProgramCoupon.where(description: params[:keyword])
#        end
#        
#    
#        search_result[:cj_offers]=CjOffer.where(advertiser_name: params[:keyword]).as_json(except: :params)
#        search_result[:avant_offers]=AvantOffer.where(advertiser_name: params[:keyword])
#    
#      
#        search_result[:cj_coupons]=CjCoupon.where(advertiser_name: params[:keyword])
#        search_result[:avant_coupons]=AvantCoupon.where(advertiser_name: params[:keyword])
#        search_result[:pj_coupons]=PjCoupon.where(advertiser_name: params[:keyword])
#        search_result[:ir_coupons]=IrCoupon.where(advertiser_name: params[:keyword])
#        search_result[:linkshare_coupons]=LinkshareCoupon.where(advertiser_name: params[:keyword])
#        search_result

#        if LoyaltyProgram.where(name: params[:keyword]).exists?
#             search_result[:loyalty_program]=LoyaltyProgram.where(name: params[:keyword])
#        end
#          if LoyaltyProgram.where(name: params[:keyword]).exists?
#             loyalty_program=LoyaltyProgram.where(name: params[:keyword])
#             loyalty_program.as_json(methods: :loyalty_program_api_params)
#          end

      
       search_result={}
       
      search_result[:Cj]=CjAdvertiser.search(params[:keyword]).as_json(only: [:id, :name])
      search_result[:Avant]=AvantAdvertiser.search(params[:keyword]).as_json(only: [:id, :name])
      search_result[:Linkshare]=LinkshareAdvertiser.search(params[:keyword]).as_json(only: [:id, :name])
      search_result[:Pj]=PjAdvertiser.search(params[:keyword]).as_json(only: [:id, :name])
      search_result[:Ir]=IrAdvertiser.search(params[:keyword]).as_json(only: [:id, :name])
      #search_result[:loyalty_program]=LoyaltyProgram.search(params[:keyword], load: true)
      
           word="%"+params[:keyword]+"%"
            if LoyaltyProgram.where("name like ?",word).exists?
                      search_result[:LoyaltyProgram]=LoyaltyProgram.where("name like ?",word).as_json(methods: :loyalty_program_api_params)   
            end
       search_result
    end
  end
  
  
  desc "coupons for advertisers"
  oauth2
  get "/advertisers/:advertiser_type/:advertiser_id/coupons" do
    if !['Cj','Pj', 'Avant', 'Linkshare', 'Ir'].include?(params[:advertiser_type])
         error!("Invalid type, It must be 'Cj','Pj', 'Avant', 'Linkshare', 'Ir'", 400)
    else
      advertiser_name=params[:advertiser_type]+"Advertiser"
      coupon_name=params[:advertiser_type]+"Coupon"
      
      if !advertiser_name.constantize.find(params[:advertiser_id]).nil?
       coupons= coupon_name.constantize.where(advertiser: advertiser_name.constantize.find(params[:advertiser_id]).advertiser_id)
      else
        error!("No Advertiser with this id", 400)
      end
    end
  end
  
  desc "offer for advertisers"
  oauth2
  get "/advertisers/:advertiser_type/:advertiser_id/offers" do
    if !['CjAdvertiser','AvantAdvertiser'].include?(params[:advertiser_type])
         error!("Invalid type, It must be 'CjAdvertiser' or 'AvantAdvertiser'", 400)
    else
      if params[:advertiser_type]=='CjAdvertiser'
        offers = params[:advertiser_type].constantize.find_by_advertiser_id(params[:advertiser_id]).cj_offers.as_json(except: :params)
      else
        offers = params[:advertiser_type].constantize.find_by_advertiser_id(params[:advertiser_id]).avant_offers
      end
     
    end
  end
 
  
  desc "get all purchase histories"
  oauth2
  get "purchase_history" do
    PurchaseHistory.all
  end  

  desc "coupons for advertiser"
  oauth2
  get "/advertiser_coupons/:type/:advertiser_id" do
    if !['cj','avant', 'pj', 'ir', 'linkshare'].include?(params[:type])
         error!("Invalid type must be 'cj' or 'avant'or 'pj' or 'ir' or 'linkshare'", 400)
    else
      advertiser = "#{params[:type].capitalize}Advertiser".constantize.find(params[:advertiser_id])
      advertiser.coupons.map(&:to_api_json)
    end
  end

  desc "all advertiser"
  oauth2
  get "/advertisers" do
    advertisers = {
      cj_advertisers: CjAdvertiser.all.as_json,
      avant_advertisers: AvantAdvertiser.all.as_json,
      pj_advertisers: PjAdvertiser.all.as_json,
      ir_advertisers: IrAdvertiser.all.as_json,
      linkshare_advertisers: LinkshareAdvertiser.all.as_json
    }
  
    advertisers.as_json
  end
  
  
  
  desc "get score value"
  oauth2
  get "/score" do
    #score=current_user.score.as_json    
    
    score= current_user.score.as_json
    score         
    
  end
  
  
  desc "instore coupons"
  oauth2
  get '/instore_coupons' do
   
    radius=5
    
    coupons=[]
    Store.all.each do |store|
      
      
       distance=store.calculate_distance(params[:lat].to_f,params[:lng].to_f)
       if distance<=radius
         if store.storable.coupons
            coupons<<store.storable.coupons.all.as_json
         end
       
       end
    end
     coupons
  end
  

  
  desc "instore loyalty program coupons"
  oauth2
  get 'user/loyalty_program/instore_coupons' do
   
   radius=5
    
   
    
   coupons=[]
    
    Store.where(storable_type: LoyaltyProgram.to_s).each do |store|
     
       distance=store.calculate_distance(params[:lat].to_f,params[:lng].to_f)
       if distance<=radius
         if !LoyaltyProgramCoupon.where(loyalty_program_id: store.storable_id).nil?
           
            coupons<<LoyaltyProgramCoupon.where(loyalty_program_id: store.storable_id).as_json
  
         end
       
       end
    end
   
     coupons
  end

  
  desc "add loyalty program"
  oauth2
  post '/user/loyalty_programs/:loyalty_program_id' do
   
    if !LoyaltyProgram.where(id: params[:loyalty_program_id]).empty?
      loyalty_program = LoyaltyProgram.where(id: params[:loyalty_program_id]).first
      if loyalty_program
        if LoyaltyProgramsUser.where(user_id: current_user.id,loyalty_program_id: params[:loyalty_program_id]).empty?
        
    
        #current_user.loyalty_programs << loyalty_program
        current_user.add_loyalty_program(loyalty_program)
        else
            error!("User already has this loyalty program", 400)
        end
        
      else
        error!("No loyalty program with this id", 400)
      end
    else
       error!("No loyalty program with this id", 400)
    end
  end
  
  desc "delete loyalty program"
  oauth2
  delete '/user/loyalty_programs/:loyalty_program_id' do
    
    
     if !LoyaltyProgram.where(id: params[:loyalty_program_id]).empty?
          loyalty_program=current_user.loyalty_programs.where(id: params[:loyalty_program_id]).first    
          if loyalty_program
                current_user.loyalty_programs.destroy(loyalty_program)
                loyalty_program.recommended=true
                loyalty_program.save
          else

             error!("User does not have this loyalty program", 400)

          end  
     else
       error!("No loyalty program with this id", 400)   
     end
     
 end
 
  desc "create new loyalty program"
  oauth2
  post '/loyalty_programs' do
    if !LoyaltyProgram.where(name: params[:name]).exists?
      
           if params[:logo_image] && params[:icon_image] && params[:name]

                loyalty_program=LoyaltyProgram.new(name: params[:name])
               
                loyalty_program.logo_image=params[:logo_image].tempfile
                loyalty_program.logo_image_file_name=params[:logo_image].filename
                loyalty_program.logo_image_content_type = params[:logo_image].type
           
                loyalty_program.icon_image=params[:icon_image].tempfile
                loyalty_program.icon_image_file_name=params[:icon_image].filename
                loyalty_program.icon_image_content_type = params[:icon_image].type
     
              if loyalty_program.save
                    if params[:account_number]
                    current_user.add_loyalty_program(loyalty_program,params[:account_number])
                    end

                    if params[:barcode_image]


                        loyalty_program_coupon=LoyaltyProgramCoupon.new()
                        loyalty_program_coupon.loyalty_program_id=loyalty_program.id
                        loyalty_program_coupon.loyalty_program_name=loyalty_program.name
                        loyalty_program_coupon.barcode_image=params[:barcode_image].tempfile
                        loyalty_program_coupon.barcode_image_file_name=params[:barcode_image].filename
                        loyalty_program_coupon.barcode_image_content_type=params[:barcode_image].type
                        loyalty_program_coupon.save

                      {loyalty_program: loyalty_program.as_json(methods: :loyalty_program_api_params),
                       loyalty_program_coupon: loyalty_program_coupon.as_json(methods: :barcode_image_url)
                      }
                    else
                       loyalty_program.as_json(methods: :loyalty_program_api_params)
                    end
              else
                 error!(loyalty_program.errors.to_a, 400)
              end    
          else
                 error!("Required parameters are missing", 400)
          end
    else
      error!("loyalty program with this name already exists", 400)
      
    end
    
  end
  

  desc "get users loyalty program"
  oauth2
  get '/users/loyalty_programs' do
    
   current_user.loyalty_programs_users.all.as_json(
     only: [:account_id, :account_number],
     include: {loyalty_program: {methods: :loyalty_program_api_params}}) 
   
  end
  
  desc "all loyalty program"
  oauth2
  get '/loyalty_programs' do
    LoyaltyProgram.all.as_json(methods: :loyalty_program_api_params)
  end
  
  
  desc "all recommended loyalty program"
  oauth2
  get '/loyalty_programs/recommended' do
    
    users_loyalty_programs=current_user.loyalty_programs_users.all.to_a
    recommended_loyalty_programs=LoyaltyProgram.where(recommended: true).to_a
    
    unique_recommended_loyalty_programs=recommended_loyalty_programs-users_loyalty_programs
    unique_recommended_loyalty_programs.as_json(methods: :loyalty_program_api_params)
  end


  desc "get loyalty program offer"
  oauth2
  get '/loyalty_programs/offers' do    
    if !LoyaltyProgramOffer.where(loyalty_program_id: params[:loyalty_program_id]).nil?        
        LoyaltyProgramOffer.where(loyalty_program_id: params[:loyalty_program_id]).all.as_json(methods: :offer_video_url)
        
    else
      error!("No loyalty program with this id", 400)
    end   
  end


  desc "add review to loyalty programs"
  oauth2
  post "/loyalty_programs/:loyalty_program_id" do
    
   
      if !LoyaltyProgram.where(id: params[:loyalty_program_id]).nil?
      
      commentable = LoyaltyProgram.where(id: params[:loyalty_program_id]).first_or_initialize
      
    
      commentable.comments.create!(
        title: current_user.first_name || "User" ,
        comment: params[:review]
      )
      
      else
        error!("No loyalty program with this id", 400)
      end
    
    
  end
  
  
  desc "get all reviews for advertiser"
  oauth2
  get '/loyalty_programs/:loyalty_program_id/reviews' do
    
    
   
      if !LoyaltyProgram.where(id: params[:loyalty_program_id]).nil?
      
        commentable = LoyaltyProgram.find(params[:loyalty_program_id])
        commentable.comments.recent.limit(10)
      
      else
        error!("No loyalty program with this id", 400)
      end
    
   
  end
  
  
  desc "get all loyalty program offers"
  oauth2
  get '/loyalty_program_offers' do
     LoyaltyProgramOffer.all.map(&:to_api_json)
  end
  
  desc "get offers detail"
  oauth2
  get '/loyalty_program_offers/:loyalty_program_offer_id' do
    LoyaltyProgramOffer.find(params[:offer_id]).to_api_json
  end
  
  desc "get all service categories"
  get '/service_categories' do
    ServiceCategory.all.map{|c| {:id=>c.id, :name=>c.name}}
  end

  desc "get all product categories"
  get '/product_categories' do
    #should probably be more clever
    #but for now just hardocoded 3 
    ProductCategory.roots.order('`order` ASC').map do |root|
      subtree = root.children.order('`order` ASC').map do |child|
        subsubtree = child.children.order('`order` ASC').map{|c| {:id => c.id,:name => c.name}}
        {:id => child.id,:name => child.name,:children=>subsubtree}
      end
      {:id => root.id,:name => root.name,:children => subtree}
    end
  end

  desc "send email invitations to muddle with referral link"
  #param contacts => []
  oauth2
  post '/referrals/invite_emails' do
    params[:contacts] ||= []    
    recipients = params[:contacts].to_a
    error_mails = []
    recipients.each_with_index do |email, idx|
      error_mails.push recipients.delete_at(idx) if (email =~ /\A.+@.+\..+\Z/).nil?
    end

    unless recipients.empty?
      #ReferralsMailer.invite(current_user, recipients, params[:custom_message]).deliver
      ReferralsMailer.invite(current_user, recipients, params[:custom_message]).deliver
    end
    result = {}
    recipients.each { |r| result[r] = true }
    error_mails.each { |r| result[r] = false }
    result
  end

  desc "get product name from recognize.im image id"
  get '/recognized_product/:id' do
    image = RecognizeImage.find params[:id]
    {
      :name=>image.best_buy_product_name,
      :images=>[{:url=>image.best_buy_image_url, :type=>'large'}]
    }
  end

  desc "deprecated for now get product name from recognize.im image id"
  get '/etilize_recognized_product/:id' do
    image = RecognizeImage.find params[:id]
    etilize_product = Etilize.product(image.etilize_id)['Product']
    images = etilize_product['resources']['resource']
    images = [images] if !images.is_a? Array
    images.delete_if {|i| i['status'] != 'Published'}
    {
      :name=>etilize_product['descriptions']['description']['__content__'],
      :images=>images.map{|i| {:url=>i['url'], :type=>i['type']}}
    }
  end
  
  #  desc "coupons for affiliates"
#  oauth2
#  get "/affiliates_coupons" do
#
#      coupons={}
#      
#      coupons[:cj_coupons] = CjCoupon.all.as_json
#      coupons[:avant_coupons] = AvantCoupon.all.as_json
#      coupons[:pj_coupons] = PjCoupon.all.as_json
#      coupons[:ir_coupons] = IrCoupon.all.as_json
#      coupons[:linkshare_coupons] = LinkshareCoupon.all.as_json
#    
#      
#      
#      coupons.as_json
#  end
  
#  desc "loyalty program coupons"
#  oauth2
#  get "/loyalty_programs/:id/loyalty_program_coupons" do  
#    loyalty_program_coupons = LoyaltyProgramCoupon.where(loyalty_program_id: params[:id])
#    loyalty_program_coupons.as_json
#  end

  ####################################################
  
    
  desc "get balance"
  oauth2
  get "/balance" do
   
    balance= {}
    balance[:total_balance]=current_user.total_balance.as_json
    balance[:balance]=(current_user.balance || 0).as_json
    balance[:unconfirmed_earnings]=current_user.unconfirmed_earnings.as_json
    
    balance
  end
  
#  desc "add advertisers image"
#  get "/advertisers/:type/:advertiser_id/:image_name" do
#    authenticated
#    #what type of parameters
#    if !['cj','avant', 'pj', 'ir', 'linkshare'].include?(params[:type])
#        error!("Invalid type must be 'cj' or 'avant'or 'pj' or 'ir' or 'linkshare'", 400)
#    else
#      advertisers 
#      if params[:type]== 'cj'
#        advertiser =CjAdvertiser.find(params[:advertiser_id])
#      elsif params[:type]=='avant'
#        advertiser =AvantAdvertiser.find(params[:advertiser_id])
#      end
#      
#      advertiser.image_name=params[:image_name]
#      
#      if advertiser.save
#          advertiser.to_api_json
#      else
#          error!(advertiser.errors.to_a, 400)
#      end
#      
#     end
#    
#  end
  
#  desc "add review to advertiser"
#  post "/advertiser/:type/:advertiser_id/:review" do
#    #authenticated 
#   
#    
#    if !['cj','avant', 'pj', 'ir', 'linkshare'].include?(params[:type])
#      error!("Invalid type must be 'cj' or 'avant'or 'pj' or 'ir' or 'linkshare'", 400)
#    else    
#      case params[:type]
#      when 'cj'
#        commentable = CjAdvertiser.where(params[:advertiser_id]).first_or_initialize
#      when 'avant'
#        commentable = AvantAdvertiser.where(params[:advertiser_id]).first_or_initialize
#      when 'pj'
#        commentable = PjAdvertiser.where(params[:advertiser_id]).first_or_initialize
#      when 'ir'
#        commentable = IrAdvertiser.where(params[:advertiser_id]).first_or_initialize
#      when 'linkshare'
#        commentable = LinkshareAdvertiser.where(params[:advertiser_id]).first_or_initialize
#      end
#      
##      commentable.comments.create!(
##        title: current_user.first_name + current_user.last_name,
##        comment: params[:review]
##      )
#        commentable.comments.create!(
#        title: current_user.first_name + current_user.last_name,
#        comment: params[:review]
#      )
#     end
#  end
#  
#  
#  desc "get all reviews for advertiser"
#  get '/advertisers/:type/:advertiser_id/reviews' do
#    #authenticated    
#    
#    if !['cj','avant', 'pj', 'ir', 'linkshare'].include?(params[:type])
#       error!("Invalid type must be 'cj' or 'avant'or 'pj' or 'ir' or 'linkshare'", 400)
#    else
#      
#      
#      case params[:type]
#      when 'cj'
#        commentable = CjAdvertiser.find(params[:advertiser_id])
#        commentable.comments.recent.limit(10)
#      when 'avant'
#        commentable = AvantAdvertiser.find(params[:advertiser_id])
#        commentable.comments.recent.limit(10)
#      when 'pj'
#        commentable = PjAdvertiser.find(params[:advertiser_id])
#        commentable.comments.recent.limit(10)
#      when 'ir'
#        commentable = IrAdvertiser.find(params[:advertiser_id])
#        commentable.comments.recent.limit(10)
#      when 'linkshare'
#        commentable = LinkshareAdvertiser.find(params[:advertiser_id])
#        commentable.comments.recent.limit(10)
#      end
#     end
#  end
#  

  
#   desc "create personal offer"
#  oauth2
#  post '/loyalty_programs/personal_offers' do
#    
#    l=LoyaltyProgram.find(params[:id])
#     if l
#            personal_offer=PersonalOffer.new()
#            
#             personal_offer.offer_barcode_image=params[:barcode_image].tempfile
#             personal_offer.offer_barcode_image_file_name=params[:barcode_image].filename
#             personal_offer.offer_barcode_image_content_type = params[:barcode_image].type
#            
#             personal_offer.offer_video=params[:video].tempfile
#             personal_offer.offer_video_file_name=params[:video].filename
#             personal_offer.offer_video_content_type = params[:video].type
#
#       
#            personal_offer.expiration_date=params[:expiration_date]
#            personal_offer.header=params[:header]
#
#           if personal_offer.save
#               l.personal_offers<< personal_offer
#           end
#    end
#  end
  
  
end

class Api < Grape::API
  format :json
  use ::WineBouncer::OAuth2
  mount MuddleMeAPI    
end
