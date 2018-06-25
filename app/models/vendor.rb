class Vendor < ActiveRecord::Base
  SENT_RECOMMENDATIONS_EVERY = 1.minute
  
  has_many :bids
  has_many :auctions, -> {select('auctions.*, bids.current_value as vendor_bid, bids.is_winning as vendor_won,  bids.max_value as vendor_max_bid')}, :through=>:bids  
  has_many :won_auctions, -> {select('auctions.*, bids.current_value as vendor_bid, bids.is_winning as vendor_won,  bids.max_value as vendor_max_bid').where({:bids=>{:is_winning=>true}})}, 
    :through=>:bids, :source=>:auction
  has_many :campaigns, :dependent=>:destroy
  has_many :offers, :dependent=>:destroy
  has_many :offer_images, -> {where("offer_id is null")}, :dependent=>:destroy
  has_many :all_offer_images, :class_name=>'OfferImage'
  has_many :funds_transfers, :dependent=>:restrict_with_error
  has_many :funds_refunds, :dependent=>:restrict_with_error
  has_one :vendor_setting, :dependent => :destroy
  has_and_belongs_to_many :service_categories
  has_and_belongs_to_many :product_categories
  has_many :keywords, -> {order('vendor_keywords.keyword ASC')}, :class_name=>'VendorKeyword', :dependent=>:destroy
  has_many :tracking_events, :class_name=>'VendorTrackingEvent', :dependent=>:destroy
  has_many :fund_grants, :class_name=>'VendorFundsGrant', :dependent=>:destroy
  has_many :transactions, -> {order('vendor_transactions.created_at, vendor_transactions.id ASC')}, :class_name=>'VendorTransaction', :dependent=>:delete_all
  has_one :loyalty_program
  
  
  
  has_and_belongs_to_many :saved_auctions, :class_name => "Auction", :uniq=>true
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
    :recoverable, :rememberable, :validatable, :encryptable, :trackable

  attr_accessor :dont_require_password_confirmation, :dont_require_password, :create_by_admin

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
    :city, :address, :zip_code, :company_name, :website_url, :review_url, :phone,
    :last_name, :terms, :first_name, :keywords, :service_category_ids, :state_abbreviation,
    :service_provider, :service_provider_keywords, :retailer, :retailer_keywords,
    :service_categories, :service_category_ids, :product_categories, :product_category_ids
  
  validates :email, :presence => true
  validates :password, :presence => true, :unless=>Proc.new{dont_require_password}
  validates :password, :confirmation => true, :unless=>Proc.new{dont_require_password_confirmation}
  validates :password_confirmation, :presence => true, :unless=>Proc.new{dont_require_password_confirmation || dont_require_password}
  validates :company_name, :presence => true
  validates :first_name, :length => { :maximum => 50 }
  validates :last_name, :length => { :maximum => 50 }
  validates :address, :length => { :maximum => 50 }
  validates :city, :length => { :maximum => 50 }
  validates :state_abbreviation, :inclusion => STATE_ABBREVIATIONS, :allow_blank=>true
  validates :zip_code, :presence => true, :format => { :with => /\A\d{5}\z/i }, :unless=>Proc.new{create_by_admin}
  validates :phone, :presence => true, :unless=>Proc.new{create_by_admin}#, :format => { :with => /^[1-9\s\-+.\(\)]*$/i }
  validates :terms, :acceptance => true, :unless=>Proc.new{create_by_admin}
  validates :service_provider, :inclusion=>{:in=>[true]}, :unless=>Proc.new{service_category_ids.blank?}
  validates :retailer, :inclusion=>{:in=>[true]}, :unless=>Proc.new{product_category_ids.blank?}

  validates :facebook_uid, :uniqueness => true, allow_blank: true
  validates :twitter_uid, :uniqueness => true, allow_blank: true
  validates :google_uid, :uniqueness => true, allow_blank: true
  
  before_validation(:on => :create) do
    if social_registration?
      self.password = Devise.friendly_token[0,20]
      self.password_confirmation = self.password
    end
  end

  scope :search, lambda {|s|
    unless s.blank?
      where_str = " vendors.first_name LIKE ?"
      where_str += " OR vendors.last_name LIKE ?"
      where_str += " OR vendors.company_name LIKE ?"
      where_str += " OR vendors.email LIKE ?"
      where_params = [where_str]
      4.times {where_params << "%#{s}%"}
      where(where_params)
    else
      self
    end
  }

  #needed for tests
  def terms
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  # overwritten devise methods: added blocking by admin functionality
  def active_for_authentication?
    super && !self.blocked
  end

  def inactive_message
    !self.blocked ? super : :blocked
  end
  
  def available_balance without_auction_or_campaign = nil, without_campaign = nil
    campaign = without_auction_or_campaign if without_auction_or_campaign.is_a?(Campaign)
    campaign = without_campaign if without_campaign
    balance.to_i - balance_locked_in_campaigns(campaign)
  end

  def balance_locked_in_campaigns without_campaign = nil
    where_str = 'status = "running"'
    where_cond = ["#{where_str} AND id <> ?", without_campaign.id] if without_campaign
    campaigns.where(where_cond || where_str).sum('budget').to_i
  end

  def calculated_balance
    balance = 0
    balance += funds_transfers.where(:status=>:success).sum('amount')
    balance -= bids.includes(:auction).where(:"auctions.status"=>'accepted', :is_winning=>true).sum('current_value')
    balance -= funds_refunds.where(:status=>['complete', 'partially_complete']).sum('refunded_amount')
  end

  def balance
    last_transaction = transactions.last
    last_transaction.nil? ? 0 : last_transaction.resulting_balance
  end

  def old_balance
    read_attribute(:balance)
  end
  
  def social_registration?
    !(facebook_uid.blank? && twitter_uid.blank? && google_uid.blank?)
  end
  
  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    self.find_for_oauth(:facebook, access_token)
  end
  def self.find_for_google_oauth(access_token, signed_in_resource=nil)
    self.find_for_oauth(:google, access_token)
  end
  
  def self.find_for_twitter_oauth(access_token, signed_in_resource=nil)
    self.find_for_oauth(:twitter, access_token)
  end
  
  def self.new_with_session(params, session)
    super.tap do |vendor|
      if basic_data = session["devise.vendor_twitter_data"]
        
        vendor.twitter_uid = basic_data.uid
        
      elsif basic_data = session["devise.vendor_facebook_data"] 
        
        vendor.facebook_uid = basic_data.uid
        
        if data = basic_data["extra"]["raw_info"]
          vendor.email = data["email"] if data["email"]
          vendor.first_name = data["first_name"] if data["first_name"]
          vendor.last_name = data["last_name"] if data["last_name"]
          vendor.city = data["location"]["name"] if (data["location"] && data["location"]["name"])
        end
        
      elsif basic_data = session["devise.vendor_google_data"]
        
        vendor.google_uid = basic_data.uid
        
        if data = basic_data["info"]
          vendor.email = data["email"] if data["email"]
          vendor.first_name = data["first_name"] if data["first_name"]
          vendor.last_name = data["last_name"] if data["last_name"]
        end
      end
    end
  end
  
  def recommended_auctions
    extra_join_contition = ''
    extra_join_contition = 'product_auction = 0 AND ' if service_provider && !retailer
    extra_join_contition = 'product_auction = 1 AND ' if retailer && !service_provider
    
    applicable_product_category_ids = (product_category_ids + product_categories.map { |c| c.descendant_ids }.flatten).uniq
    latest_auctions.where(['product_category_id IN (?) OR service_category_id IN (?) OR vendor_keywords.id IS NOT NULL', 
        applicable_product_category_ids, service_category_ids]).
    joins("LEFT OUTER JOIN vendor_keywords ON vendor_keywords.vendor_id = #{id} AND #{extra_join_contition}
          auctions.name LIKE CONCAT('%', vendor_keywords.keyword ,'%')").
    group('auctions.id')
  end
  
  def latest_auctions
    Auction.joins("LEFT OUTER JOIN `bids` ON `bids`.`auction_id` = `auctions`.`id` AND `bids`.`vendor_id`= #{id}" ).
    where(['auctions.end_time > ? AND (bids.vendor_id <> ? OR bids.vendor_id IS NULL)', Time.now, id])
  end
  
  def send_recommendations
    if EmailContent.recommended_auctions_mail?
      return unless recommended_auctions_mail?
      auctions = recommended_auctions
      auctions = auctions.where('auctions.created_at > ? ', recommendations_sent_at) unless recommendations_sent_at.blank?
      AuctionsMailer.delay.recommended_auctions(self, auctions) unless auctions.blank?
      update_attribute :recommendations_sent_at, Time.now
    end
  end

  #settings
  def recommended_auctions_mail?
    vendor_setting.nil? || vendor_setting.recommended_auctions_mail.nil? ? true : vendor_setting.recommended_auctions_mail
  end

  def auction_status_mail?
    vendor_setting.nil? || vendor_setting.auction_status_mail.nil? ? true : vendor_setting.auction_status_mail
  end

  def auction_result_mail?
    vendor_setting.nil? || vendor_setting.auction_result_mail.nil?  ? true : vendor_setting.auction_result_mail
  end

  def contact_info_mail?
    vendor_setting.nil? || vendor_setting.contact_info_mail.nil?  ? true : vendor_setting.contact_info_mail
  end

  def auto_bid_mail?
    vendor_setting.nil? || vendor_setting.auto_bid_mail.nil?  ? true : vendor_setting.auto_bid_mail
  end
  
  def auto_confirm_outcomes?
    vendor_setting.nil? || vendor_setting.auto_confirm_outcomes.nil?  ? true : vendor_setting.auto_confirm_outcomes
  end

  private
  def self.find_for_oauth(provider, access_token)
    if vendor = Vendor.where(:"#{provider}_uid"=>access_token.uid).first
      #TODO ?? are we updating other social attributes that might have changed??
      vendor.update_without_password(:"#{provider}_token=" => access_token['credentials']['token'])
      vendor
    else
      ## Create a vendor with a stub password. 
      # Vendor.create!(:email => data.email, :password => Devise.friendly_token[0,20])
      nil
    end
  end
  
end
