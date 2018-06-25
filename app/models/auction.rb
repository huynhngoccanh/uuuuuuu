class Auction < ActiveRecord::Base
  STATUSES = ['active', 'resolved', 'confirmed', 'unconfirmed', 'accepted', 'rejected']
  BUDGET_OPTIONS = $auction_budget_options
  VENDOR_RESTRICTIONS = ['angie', 'angie_A', 'angie_B']
  ADD_TO_ID = 1022
  DELIVERY_OPTIONS = ['shipping', 'self']
  USER_EARNINGS_SHARE = 0.7
  CANT_CONFIRM_AFTER = 60.days
  VENDOR_CANT_REJECT_AFTER = 2.weeks
  AFFILIATE_OFFER_ACCEPT_AFTER = 2.weeks
  
  CONFIRMATION_NEEDED_TEXT = 'confirmation needed'
  OUTCOME_STATUSES = ['running', 'processing', 'no_bids', 'no_outcome', 'outcome_negative', 'confirmation_needed', 'confirmed_negative', 'confirmed_positive', 'auto_confirmed_positive']

  belongs_to :user
  belongs_to :service_category
  belongs_to :product_category

  has_many :bids, -> {order('bids.max_value DESC, bids.updated_at ASC, bids.id ASC ')}, :dependent=>:destroy 
  has_many :winning_bids, -> {order('bids.max_value DESC, bids.updated_at ASC, bids.id ASC ').where({:is_winning=>true})}, :class_name=>'Bid'
  has_one :highest_bid, -> {order('bids.max_value DESC')}, :class_name=>'Bid'
  has_one :lowest_bid, -> {order('bids.max_value ASC')}, :class_name=>'Bid'
  
  has_many :archived_bids, :dependent=>:destroy
  has_many :participants, :source=>:vendor, :through=>:bids
  has_many :winners, -> {where(:bids=>{:is_winning=>true})}, :through=>:bids, :source=>:vendor
  has_one :outcome, :class_name=>'AuctionOutcome', :dependent=>:destroy

  has_and_belongs_to_many :saved_by_vendors, :class_name=>'Vendor', :uniq=>true

  has_many :auction_images, :dependent=>:destroy
  has_one :auction_address, :dependent=>:destroy
  has_many :vendor_tracking_events, :dependent=>:nullify
  has_many :cj_offers, :dependent=>:destroy
  has_many :avant_offers, :dependent=>:destroy
  has_many :offers, -> {where({:bids=>{:is_winning=>true}})}, :through=>:bids
  has_one :user_transaction, :as=>:transactable, :dependent=>:destroy
  has_many :muddleme_transactions, :as=>:transactable, :dependent=>:destroy

  # validates :user_id, :presence=>true
  validates :product_category_id, :presence=>true, :if=>Proc.new{|a| a.product_auction}
  validates :product_category, :presence=>true, :if=>Proc.new{|a| a.product_auction}
  validates :service_category_id, :presence=>true, :if=>Proc.new{|a| !a.product_auction}
  validates :service_category, :presence=>true, :if=>Proc.new{|a| !a.product_auction}
  validates :status, :presence=>true, :inclusion => {:in=>STATUSES}
  validates :name, :presence=>true, :length => { :maximum => 80 }
  validates :duration, :presence=>true, :numericality=>{:greater_than => 0, :less_than => 15, :only_integer => true }
  validates :budget, :presence=>true, :inclusion => {:in=>BUDGET_OPTIONS}
  validates :min_vendors, :numericality=>{:greater_than => 0, :less_than => 11, :only_integer => true}, :allow_blank=>true
  validates :max_vendors, :presence=>true, :numericality=>{ :less_than => 11, :only_integer => true}
  validates_greather_or_equal_to_other_attr :max_vendors, :min_vendors
  validates :contact_time, :presence=>true, :if=>Proc.new{|a| !a.contact_time_to.blank?}
  validates :contact_time_of_day, :inclusion => {:in=>$times_of_day}, :allow_blank=>true
  validates :contact_way, :inclusion => {:in=>$contact_ways}, :allow_blank=>true
  #TODO: online validation for delivery_method
  validates :delivery_method, :presence=>true, :inclusion => {:in=>DELIVERY_OPTIONS}, :if=>Proc.new{|a| a.product_auction}
  validates :vendor_restriction, :inclusion => {:in=>VENDOR_RESTRICTIONS}, :allow_blank=>true
  validates :end_time, :presence=>true
  validates :extra_info, :length => { :maximum => 200 }
  validates :claimed_score, :numericality=>{:greater_than_or_equal_to => 0, :less_than_or_equal_to => 100, :only_integer => true}, :allow_blank=>true


  #validates :budget_min, :presence => true, :if => Proc.new{|a| a.budget == 'custom'}
  #validates :budget_max, :presence => true, :if => Proc.new{|a| a.budget == 'custom'}

  validates_greather_or_equal_to_other_attr :budget_max, :budget_min

  before_validation :default_values

  accepts_nested_attributes_for :auction_address, :auction_images

  attr_protected :user_id, :status, :end_time, :score
  
  after_create :autobid_campaigns

  scope :search, lambda {|s|
    unless s.blank?
      where_str = " auctions.name LIKE ?"
      where_str += " OR auctions.extra_info LIKE ?"
      where_str += " OR cast(auctions.id+#{ADD_TO_ID} as char) LIKE ?"
      where_params = [where_str]
      3.times {where_params << "%#{s}%"}
      where(where_params)
    else
      self
    end
  }

  scope :date_filter, lambda {|f, op, val|
    if f.blank? || op.blank? || val.blank?
      self
    else
      date = Date.strptime(val, "%m/%d/%y")
      where_str = " auctions.#{f} #{op} ? "
      where_params = [where_str, date]
      where(where_params)
    end
  }

  def self.resolve_finished_auctions
    self.where(['auctions.end_time < ? AND status="active"', Time.now]).each do |auction|
      auction.resolve_auction
    end
  end

  def self.reject_acutions_users_can_no_longer_confirm
    end_time_before = Time.now - CANT_CONFIRM_AFTER
    Auction.where(['auctions.end_time < ? AND status="unconfirmed"', end_time_before]).each do |auction|
      auction.reject_auction
    end
  end

  def self.accept_auctions_vendors_can_no_longer_reject
    confirmed_at_before = Time.now - VENDOR_CANT_REJECT_AFTER
    Auction.includes(:outcome).
      where(['auction_outcomes.confirmed_at < ? AND status="confirmed"', confirmed_at_before]).each do |auction|
      auction.accept_auction
    end
  end

  def self.accept_affiliate_offer_after_waiting_period
    confirmed_at_before = Time.now - AFFILIATE_OFFER_ACCEPT_AFTER
    Auction.includes(:user, :outcome, {:cj_offers=>:commission, :avant_offers=>:commission} ).
      where(' cj_commissions.id IS NOT NULL OR avant_commissions.id IS NOT NULL').
      where(['auction_outcomes.confirmed_at < ? AND status="confirmed"', confirmed_at_before]).each do |auction|
      
      auction.update_attribute :status, 'accepted'
      UserScore.add_score_for_auction auction
      
      UserTransaction.create_for auction
      unless auction.user.referred_visit.blank?
        auction.user.referred_visit.add_referred_earnings
        UserTransaction.create_for auction.user.referred_visit 
      end

      affiliate_commission = (auction.cj_offers.to_a + auction.avant_offers.to_a).
                             select{|o| !o.commission.blank?}.first.commission

      MuddlemeTransaction.create_for affiliate_commission
    end
  end

  def product_auction?
    !!product_auction
  end

  def number
    self.id + ADD_TO_ID
  end

  def duration_string
    return "#{duration / 7} week#{duration/7 > 1 ? 's':''}" if (duration % 7).zero?
    return "1 day" if duration == 1
    "#{duration} days"
  end

  def in_progress?
    end_time > Time.now
  end

  def bidding_finished?
    !in_progress?
  end

  def resolved?
    bidding_finished? && status != 'active'
  end

  def unresolved?
    bidding_finished? && status == 'active'
  end

  def combined_affiliate_offers
    max_offers = 8
    active_avant_offers = avant_offers.includes(:advertiser).where('avant_advertisers.id is not null')
    active_cj_offers = cj_offers.includes(:advertiser).where('cj_advertisers.id is not null')
    avant_offers_count = [active_avant_offers.length, 4].min
    cj_offers_count = [active_cj_offers.length, 4].min
    active_cj_offers.first(max_offers - avant_offers_count) + active_avant_offers.first(max_offers - cj_offers_count)
  end

  def affiliate_comission
    return @affiliate_comission unless @affiliate_comission.nil?
    offer = (cj_offers.to_a + avant_offers.to_a).select{|o| !o.commission.blank?}.first
    @affiliate_comission = offer && offer.commission
  end

  def resolve_auction force=false, dont_send_emails = false
    result = []
    return result if status != 'active'
    if Time.now < end_time
      return result unless force
      update_attribute :end_time, Time.now
    end

    winning_bids = {}
    ordered_bids = bids.order('max_value DESC, updated_at DESC').includes(:vendor)
    unless ordered_bids.length < min_vendors.to_i
      ordered_bids.limit(max_vendors).update_all(:is_winning=>true)
      ordered_bids.limit(max_vendors).each do |bid|
        result << bid.vendor
        winning_bids[bid.vendor.id] = bid
      end
    end

    if result.length > 0
      update_attribute(:status, 'unconfirmed')
      if !outcome #create outcome object
        o = build_outcome
        o.save :validate=>false
      end
      update_attribute(:user_earnings, calculate_user_earnings)
    else
      update_attribute(:status, 'resolved')
    end


    if result.length > 0 && !dont_send_emails
      AuctionsMailer.delay.auction_won_user(self) if EmailContent.auction_won_user_mail? #send mail to user that auction was won
      result.each do |vendor|
        AuctionsMailer.delay.auction_won_vendor(self, vendor) if EmailContent.auction_won_vendor_mail? #send mail to vendor that he won the auction
      end
      self.user.post_auction_won_to_facebook user_earnings
      self.user.post_auction_won_to_twitter user_earnings
    elsif !dont_send_emails && EmailContent.auction_ended_user_mail? && self.user.ended_auction_mail?
      AuctionsMailer.delay.auction_ended_user(self) #send mail to user that auction ended with no bids
    end

    result
  end

  def confirm_auction
    return if status == 'confirmed'
    if end_time + CANT_CONFIRM_AFTER < Time.now
      update_attribute :status, 'rejected'
      errors.add(:status, "can't confirm auction anymore deadline expired")
      return
    end

    update_attribute(:status, 'confirmed')
  end

  def accept_auction
    #can only accept when status is confirmed
    return if status != 'confirmed'

    update_attribute :status, 'accepted'
    UserScore.add_score_for_auction self

    winning_bids.includes(:vendor).each do |bid|
      if !bid.vendor.low_funds_notification_sent_at.nil? && bid.vendor.balance >= FundsTransfer::MIN_AMOUNT
        bid.vendor.update_attribute :low_funds_notification_sent_at, nil
      end

      VendorTransaction.create_for bid

      #send mail to vendor that his balance is running low
      if EmailContent.low_funds_notification_global_mail? && bid.vendor.low_funds_notification_sent_at.nil? && 
          bid.vendor.balance < FundsTransfer::MIN_AMOUNT

        AuctionsMailer.delay.low_funds_notification(bid.vendor) 
        bid.vendor.update_attribute :low_funds_notification_sent_at, Time.now
      end

      unless bid.campaign_id.nil?
        bid.update_attribute :offer_id, bid.campaign.offer_id
          
        if !bid.campaign.low_funds_notification_sent_at.nil? && !bid.campaign.budget.nil? &&
            bid.campaign.budget_left >= Campaign::MIN_BUDGET
          bid.campaign.update_attribute :low_funds_notification_sent_at, nil
        end
        
        campaign_calculated_total_spent = bid.campaign.calculated_total_spent
        if campaign_calculated_total_spent - bid.campaign.total_spent.to_i != bid.current_value
          #TODO send email that the balance was wrong
          #abort('Somthing was wrong bad total spent'.to_yaml)
        end
        bid.campaign.update_attribute(:total_spent, campaign_calculated_total_spent)

        #send mail to vendor that the campaign budget is running low
        bid_campaign = bid.campaign
        if EmailContent.low_funds_notification_campaign_mail? && !bid_campaign.nil? && 
            bid_campaign.low_funds_notification_sent_at.nil? && !bid_campaign.budget.nil? &&
            bid_campaign.budget_left < Campaign::MIN_BUDGET 
          AuctionsMailer.delay.low_funds_notification(bid.vendor, bid_campaign) 
          bid_campaign.update_attribute :low_funds_notification_sent_at, Time.now
        end
      end
    end

    UserTransaction.create_for self
    unless user.referred_visit.blank?
      user.referred_visit.add_referred_earnings
      UserTransaction.create_for user.referred_visit 
    end
    MuddlemeTransaction.create_for self
  end

  def confirm_from_affiliate_offer affiliate_offer
    return if affiliate_offer.commission.nil?
    bids.delete_all
    if Time.now < end_time
      update_attribute :end_time, Time.now
    end

    commission_amount = affiliate_offer.commission.commission_amount.to_f * USER_EARNINGS_SHARE
    
    if !outcome #create outcome object
      o = build_outcome
      o.save :validate=>false
    end
    outcome.update_attribute :purchase_made, true
    outcome.update_attribute :confirmed_at, Time.now

    update_attribute :user_earnings, commission_amount
    update_attribute :status, 'confirmed'

    AuctionsMailer.delay.auction_ended_from_affiliate(self, affiliate_offer)

    MuddlemeTransaction.create_for affiliate_offer.commission
  end

  def reject_auction
    update_attribute :status, 'rejected'
    UserScore.add_score_for_auction self
  end

  def calculate_user_earnings
    (total_earnings.to_f * USER_EARNINGS_SHARE)
  end

  def total_earnings
    return @total_earnings unless @total_earnings.nil?
    @total_earnings = if unresolved? || winning_bids.length == 0
      0
    else
      (winning_bids.length * winning_bids.first.current_value)
    end
  end
  
  def autobid_campaigns
    # only update bids that are not manual ??
    return if end_time <= Time.now()
    return if applicable_campaigns.blank?
    
    all_campaign_bids_are_winning = applicable_campaigns.index do |c|
      vendor_bid = bids.to_a.find{|b| b.vendor_id == c.vendor_id}
      vendor_bid.nil? || #thers no bid for this auction
        (!vendor_bid.campaign_id.nil? && vendor_bid.campaign_id != c.id) || # the bid is form diffrent campaign
        (vendor_bid.campaign_id == c.id && !bids[0,max_vendors].include?(vendor_bid)) # or the bid for this auction its not winning
    end.nil?

    return if all_campaign_bids_are_winning
    
    
    manual_bids_winning = bids.to_a[0, max_vendors].select{|b| b.campaign_id.nil?}
    
    #reject campaigns that dont have enough funds
    applicable_campagins_with_enugh_funds = applicable_campaigns
    begin
      #calculate treshold value
      if applicable_campagins_with_enugh_funds.count > max_vendors - manual_bids_winning.length
        highest_max_bids = applicable_campagins_with_enugh_funds.map{|c| c.max_bid}
        highest_max_bids += manual_bids_winning.map{|b| b.max_value}
        highest_max_bids.sort!{|x,y| y <=> x }

        lowest_above_treshold = highest_max_bids[max_vendors - 1]
        highest_below_treshlod = highest_max_bids[max_vendors]
        treshold_value = [lowest_above_treshold, highest_below_treshlod + bid_value_step].min
      else
        treshold_value = bid_entry_value
      end
      
      nothing_more_to_reject = applicable_campagins_with_enugh_funds.reject! do |campaign|
        bid_max_value = [campaign.max_bid, treshold_value].min
        if !campaign.budget.nil? && bid_max_value > campaign.available_budget(self)
          next true
        end
        if bid_max_value > campaign.vendor.available_balance(self, campaign)
          next true
        end
        false
      end.nil?
    end until nothing_more_to_reject
    
    order_by_max_bids_desc_and_shuffle_same_max_bids(applicable_campagins_with_enugh_funds).each do |campaign|
      
      vendor_bid = bids.to_a.find{|b| b.vendor_id == campaign.vendor_id}
      
      bid_max_value = [campaign.max_bid, treshold_value].min
      
      #create/update bids
      #attributes are protected thats why we use '.' insted of mass assign
      if !vendor_bid
        new_bid = bids.build({:max_value=>bid_max_value.round.to_i})
        new_bid.vendor = campaign.vendor
        new_bid.vendor_id = campaign.vendor_id
        new_bid.campaign = campaign
        new_bid.campaign_id = campaign.id
        new_bid.save!
      elsif !vendor_bid.campaign_id.nil?
        vendor_bid.campaign = campaign
        vendor_bid.campaign_id = campaign.id
        vendor_bid.max_value = bid_max_value.round.to_i
        vendor_bid.save!
      end
      Bid.where({:id=>manual_bids_winning.map{|b| b.id}}).update_all({:updated_at=>Time.now+1.second})
      bids.reload
    end
    update_bids_current_values
  end
  
  def applicable_campaigns
    return @applicable_campaigns unless @applicable_campaigns.nil?
    
    Campaign.check_stop_dates_and_update
    
    category_type = product_auction ? :product : :service
    categories = if product_auction
      product_category.ancestor_ids <<  product_category_id
    else
      service_category_id
    end
    manual_bidder_ids = participants.where('bids.campaign_id IS NULL').map{|v| v.id}
    @applicable_campaigns = Campaign.includes( :"#{category_type}_categories", :auctions, :bids).
      where({:status=>'running', :product_campaign=>product_auction, 
        :"#{category_type}_categories.id"=>categories}).                                                        #match categories
      where(['(score_min <= ? OR score_min IS NULL) AND (score_max >= ? OR score_max IS NULL)', score, score]). #remove if score doesn't match
      where(['campaigns.vendor_id NOT IN (?)', manual_bidder_ids.blank? ? 0 : manual_bidder_ids]).              #remove campaigns by vendors who have manual bids in this auctions
      order('campaigns.updated_at DESC')                                                                        #in case of duplicate vendor ids take newest campaign
      
    unless bids.count.zero?
      @applicable_campaigns = @applicable_campaigns.where(['max_bid >= ?', bid_entry_value])                    #remove if max bid too low
    end
    @applicable_campaigns = reject_duplicates_by @applicable_campaigns, :vendor_id                              #remove duplicates using http://stackoverflow.com/a/1591008
  end
  
  def update_bids_current_values
    return if bids.count.zero?
    if bids.count > max_vendors
      highest_bids = bids.order('max_value DESC, updated_at ASC, bids.id ASC').offset(max_vendors-1).limit(2)
      lowest_above_treshold = highest_bids.first.max_value
      highest_below_treshlod = highest_bids.second.max_value
      treshold_value = [lowest_above_treshold, highest_below_treshlod + bid_value_step].min
      bids.update_all ['current_value = LEAST(?, max_value)', treshold_value]
    else
      bids.update_all :current_value => bid_minimum_value
    end
  end
  
  #minumum bid to enter auction (be one of the current winners)
  def bid_entry_value
    max_vendors
    if bids.count < max_vendors
      bid_minimum_value
    else
      bids.order('max_value DESC, updated_at ASC').offset(max_vendors-1).limit(1)[0].max_value +
        bid_value_step
    end
  end
  
  #minimum bid for auction when no ther's other bidders or bidders num is lower than max winners
  # for now hardcoded
  #TODO either make it settable by user per auction or calculate based on score (or both)
  def bid_minimum_value
    3
  end
  
  #for now 1
  def bid_value_step
    1
  end


  def outcome_status_for_vendor vendor
    status_texts = {
        :active => end_time < Time.now ? 'running' : 'processing',
        :resolved => 'no_bids',
        :unconfirmed=> 'no_outcome'
    }
    if ['confirmed', 'accepted','rejected'].include? status.to_s
      if outcome.vendors.include? vendor
        vendor_outcome = outcome.vendor_outcomes.to_a.find{|vo| vo.vendor_id == vendor.id}
        if vendor_outcome.accepted
          vendor_outcome.auto_accepted ? 'auto_confirmed_positive' : 'confirmed_positive'
        else
          vendor_outcome.accepted.nil? ? 'confirmation_needed' : 'confirmed_negative'
        end
      else
        'outcome_negative'
      end
    else
      status_texts[status.to_sym]
    end
  end

  def status_text_for_vendor vendor
    status_texts = {
      :active => end_time < Time.now ? 'running' : 'processing',
      :resolved => 'finished without bids',
      :unconfirmed=> 'finished unconfirmed outcome'
    }
    if ['confirmed', 'accepted','rejected'].include? status.to_s
      if outcome.vendors.include? vendor
        vendor_outcome = outcome.vendor_outcomes.to_a.find{|vo| vo.vendor_id == vendor.id}
        if vendor_outcome.accepted
          vendor_outcome.auto_accepted ? "auto confirmed" : "confirmed"
        else
         vendor_outcome.accepted.nil? ? CONFIRMATION_NEEDED_TEXT : "rejected confirmation"
        end
      else
        "outcome negative"
      end
    else
      status_texts[status.to_sym]
    end
  end
  
  def delay_fetch_affiliate_offers
    return unless self.product_auction
    update_attribute :loading_affiliate_offers, true
    self.delay.fetch_affiliate_offers
  end

  def fetch_affiliate_offers
    return unless self.product_auction
    CjOffer.fetch_offers_for_auction(self)
    AvantOffer.fetch_offers_for_auction(self)
    update_attribute :loading_affiliate_offers, false
  end

  def to_api_json
    attrs = [
      :id, :name, :user_id, :status, :product_auction, :duration, :budget, :min_vendors, :max_vendors, :desired_time, :contact_time,
      :contact_time_to, :contact_time_of_day, :extra_info, :desired_time_to, :contact_way, :delivery_method, :score, :end_time,
      :user_earnings, :budget_min, :budget_max, :claimed_score, :number, :loading_affiliate_offers, :from_mobile
    ]
    result = attrs.inject({}) {|result, attr| result[attr] = send(attr.to_s); result}
    result[:service_category] = service_category && service_category.name
    result[:product_category] = product_category && product_category.name
    result[:images] = auction_images.map(&:to_api_json)
    if resolved?
      result[:winning_bids] = winning_bids.includes(:vendor).map(&:to_api_json)
    else
      result[:bids] = bids.includes(:vendor).map(&:to_api_json)
    end
    if !loading_affiliate_offers
      result[:affiliate_offers] = combined_affiliate_offers.map(&:to_api_json)
    end
    result
  end

  private
  
  def reject_duplicates_by array, key
    seen_keys = []
    return array.reject do |object| 
      if ! object.send(key).nil? && seen_keys.include?(object.send(key))
        true
      else 
        seen_keys << object.send(key)
        false
      end
    end
  end
  
  def order_by_max_bids_desc_and_shuffle_same_max_bids campaigns
    result = []
    shuffle_part = []
    campaigns = campaigns.sort{|x,y| x.max_bid <=> y.max_bid }
    campaigns.each_with_index do |c, i|
      if campaigns[i+1] && campaigns[i+1].max_bid == c.max_bid
        shuffle_part << c if shuffle_part.blank?
        shuffle_part <<  campaigns[i+1]
      else
        if !shuffle_part.blank?
          result += shuffle_part.shuffle
          shuffle_part = []
        else
          result << c
        end
      end
    end
    result
  end

  def default_values
    self.status ||= 'active'
    if !score
      user = self.user || User.find_by_id(user_id)
      self.score = user.score unless user.nil?
    end
    self.end_time ||= (created_at || Time.now) + duration.to_i.days
  end
  
end
