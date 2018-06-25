class Campaign < ActiveRecord::Base
  STATUSES = ['running', 'stopped', 'deleted']
  MIN_BUDGET = 10
  MIN_BID = 3

  belongs_to :vendor
  belongs_to :offer
  has_and_belongs_to_many :product_categories
  has_and_belongs_to_many :service_categories
  has_and_belongs_to_many :zip_codes, :uniq=>true
  has_many :bids, :dependent=>:restrict_with_error

  has_many :search_merchants, :class_name => 'Search::LocalMerchant', :foreign_key => 'db_id'
  
  validates :vendor_id, :presence=>true
  validates :offer_id, :presence=>true
  validates :offer, :presence=>true
  validates :name, :presence=>true, :length => { :maximum => 200 }
  validates :product_category_ids, :presence=>true, :if=>Proc.new{|c| c.product_campaign}
  validates :service_category_ids, :presence=>true, :if=>Proc.new{|c| !c.product_campaign}
  validates :status, :presence=>true, :inclusion => {:in=>STATUSES}
  validates :zip_code, :allow_blank=>true, :length => { :maximum => 5 }, :format => { :with => /\A\d{5}\z/i }
  validates :zip_code_miles_radius, :allow_blank=>true, :numericality=>{ :greater_than => 0, :only_integer => true}

  validates_greather_or_equal_to_other_attr :score_max, :score_min

  validates :min_bid, :allow_blank=>true, :numericality=> { :greater_than_or_equal_to => MIN_BID }
  validates :max_bid, :allow_blank=>true, :numericality=> { :greater_than_or_equal_to => MIN_BID }
  validates :fixed_bid, :allow_blank=>true, :numericality=> { :greater_than_or_equal_to => MIN_BID }
  validates :budget, :allow_blank=>true, :numericality=> { :greater_than_or_equal_to => MIN_BUDGET }

  validates_greather_or_equal_to_other_attr :max_bid, :min_bid
  validates_greather_or_equal_to_other_attr :budget, :total_spent
  validates_less_or_equal_to_other_attr :budget, :vendor_balance
  validates_less_or_equal_to_other_attr :max_bid, :budget

  validate :validate_zip_code
  
  before_validation :default_values

  before_save :add_zip_codes_from_radius
  
  attr_protected :vendor_id, :status
  
  after_save do
    applicable_auctions.each {|a| a.autobid_campaigns} if status=='running'
  end

  scope :search_by_category_name, lambda { |s|
    joins('LEFT JOIN  `campaigns_product_categories` ON  `campaigns_product_categories`.`campaign_id` =  `campaigns`.`id`
LEFT JOIN  `product_categories` ON  `product_categories`.`id` =  `campaigns_product_categories`.`product_category_id`
LEFT JOIN  `campaigns_service_categories` ON  `campaigns_service_categories`.`campaign_id` =  `campaigns`.`id`
LEFT JOIN  `service_categories` ON  `service_categories`.`id` =  `campaigns_service_categories`.`service_category_id` ').where('campaigns.status = ?', 'running').where("service_categories.name LIKE '%#{s}%' or product_categories.name LIKE '%#{s}%'").group('campaigns.id')
  }

  def score_range
    return nil if score_min.nil? || score_max.nil?
    "#{score_min}-#{score_max}"
  end
  
  def score_range= val
    min_max = val.split '-'
    if min_max[0].nil? || min_max[1].nil? ||
        (min_max[0].to_i == 0 && min_max[0].to_i == min_max[1].to_i)
      self.score_min= nil
      self.score_max= nil
      return
    end
    self.score_min= min_max[0].to_i
    self.score_max= min_max[1].to_i
  end

  def auctions_won
    auctions.where(:'bids.is_winning' => true)
  end

  def searches_won
    search_merchants.joins('INNER JOIN search_intent_outcomes ON (search_intent_outcomes.intent_id = search_merchants.intent_id and search_intent_outcomes.merchant_id = search_merchants.id and search_intent_outcomes.purchase_made=1)')
  end

  def efficiency
    merchants_count = search_merchants.count
    merchants_count == 0 ? 0 : searches_won.count.to_f / merchants_count
  end

  def calculated_total_spent
    auctions.where(:'bids.is_winning' => true, :"auctions.status"=>'accepted').
      sum('bids.current_value').to_i
  end
  
  def available_budget without_auction = nil
    budget.to_i - total_spent.to_i
  end
  
  #budget left without substracting currently locked in auctions
  def budget_left
    budget - total_spent.to_i
  end
  
  def duration
    @duration
  end
  
  def duration= value
    @duration = value
    return if  value.to_i == 0
    self.stop_at ||= (Date.today + value.to_i.days)
  end
  
  def vendor_balance
    vendor.available_balance(self)
  end
  
  def applicable_auctions
    category_type = product_campaign ? :product : :service
    categories = if product_campaign
      #sum arrrays here product_categories.ancestor_ids <<  product_category_id
      (product_category_ids + product_categories.map { |c| c.descendant_ids }.flatten).uniq
    else
      service_category_ids
    end
    
    result = Auction.where({:status=>'active', :product_auction=>product_campaign, 
        :"#{category_type}_category_id"=>categories}).
        where('end_time > UTC_TIMESTAMP()')
    result = result.where(['auctions.score between ? AND ?', score_min, score_max]) unless score_range.nil?
    unless self.zip_codes.blank?
      result = result.includes(:user).where(:"users.zip_code"=>self.zip_codes.map(&:code))
    end
    result
  end
  
  def self.check_stop_dates_and_update
    where('status="running" AND stop_at < ? ', Time.now).update_all({:status=>'stopped'})
  end
  
  def default_values
    self.status ||= 'running'
  end

  def validate_zip_code
    return if zip_code.blank?
    
    if ZipCode.find_by_code(zip_code).blank?
      errors.add :zip_code, "The zip code provided doesn't exist"
    end
  end

  def add_zip_codes_from_radius
    self.zip_codes = []
    return if zip_code.blank?
    base_code = ZipCode.find_by_code(zip_code)
    codes = [base_code]
    if zip_code_miles_radius
      codes = ZipCode.within(zip_code_miles_radius, :origin=>base_code)
    end
    self.zip_codes = codes
  end
end
