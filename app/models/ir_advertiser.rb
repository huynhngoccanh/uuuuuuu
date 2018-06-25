
class IrAdvertiser < ActiveRecord::Base
  MAX_PARALLEL_QUERIES = 100
  serialize :params
  belongs_to :merchant
  #has_many :ir_advertiser_category_mappings
  #has_many :product_categories, :through => :ir_advertiser_category_mappings
  has_many :coupons, :class_name=>'IrCoupon', :foreign_key=>'advertiser_id', :primary_key=>'advertiser_id', :dependent=>:restrict_with_error
  has_many :unexpired_coupons, -> {where('expires_at IS NULL or expires_at >= ?', Date.today)}, :class_name=>'IrCoupon', :foreign_key=>'advertiser_id', :primary_key=>'advertiser_id', :dependent=>:restrict_with_error
  has_many :favorite_advertisers, :dependent => :destroy
  has_many :hp_stores, :dependent => :destroy
  has_one :hp_advertiser_image,  :as => :imageable, :dependent=>:destroy
  has_many :stores, :as => :storable, :dependent=>:destroy
  has_many :user_coupons, :as => :advertisable
  has_many :favorite_merchants, :as => :advertisable
  
  has_attached_file :image,
    MuddleMe::Configuration.paperclip_options[:ir_advertisers][:image]
  validates_attachment_content_type :image, :content_type=>BROWSER_SUPPORTED_IMAGE_MIME_TYPES


  has_attached_file :logo,
    MuddleMe::Configuration.paperclip_options[:ir_advertisers][:logo]
  validates_attachment_content_type :logo, :content_type=>BROWSER_SUPPORTED_IMAGE_MIME_TYPES
  require "open-uri"

  validates :advertiser_id, :presence => true
  validates :name, :presence => true

  # include Tire::Model::Search
  # include Tire::Model::Callbacks


  acts_as_commentable
  

  def self.reload_all_advertisers
    puts 'IrAdvertiser.reload_all_advertisers'
    advertisers_to_delete = self.where(:inactive=>[false,nil]).to_a
    page = 0
    inserted_count = 0
    begin
      page += 1
      advertisers = IR.joined_advertisers page
      #self.collect_generic_links advertisers
      unless advertisers.blank?
        p advertisers
        self.transaction do
          advertisers.each do |row|
            advertiser = advertisers_to_delete.find { |a| a.advertiser_id == row['CampaignId'] }
            advertisers_to_delete.delete(advertiser) if advertiser
            advertiser ||= self.where(advertiser_id: row['CampaignId']).first_or_initialize
            saved = advertiser.set_attributes_from_response_row(row).save
            @merchant = Merchant.where(name: "#{row['AdvertiserName']}").first_or_initialize
            @merchant.image = advertiser.logo
            if @merchant.new_record?
              @merchant.save
            end
            @merchant.update_attributes(active_status: true)
            advertiser.update_attributes(merchant_id: @merchant.id)
            @merchant.update_merchant_slug
            inserted_count += 1 if saved
            end
        end
      end
    end
    inserted_count
    $notify_team.each do |developer|
      ContactMailer.new_advertisers_data_notification("Impact Radius", developer).deliver
    end
  end

  def set_attributes_from_response_row row
    self.name                         = row["AdvertiserName"]
    self.advertiser_id          = row["CampaignId"]
    self.mobile_enabled    = false
    self.logo                          = open(URI.parse("https://d2428jutcmfhvt.cloudfront.net"+row["CampaignLogoUri"]))
    self.params                     = row
    self.inactive                    = false
    self.max_commission_percent = generate_commission_amount(row["AdvertiserName"])
    self.generic_link           = row["TrackingLink"]
    self
  end

  def generate_commission_amount(advertiser_name)
    case advertiser_name
    when "Target"
      payout  = 3
    when "Diapers.com", "Quidsi, Inc."
      payout  = 2
    when "DNA Footwear"
      payout  = 8
    when "Echo Design Group Inc."
      payout = 6
    when "Fanzz"
      payout = 8
    when "Mrs. Fields"
      payout = 8
    when "Tommy Hilfiger"
      payout = 7
    end
    payout
  end

  def advertiser_url
    params['AdvertiserUrl']
  end

  def base_tracking_url
    generic_link
  end

  def self.relevant_search(search_string)
    search_string = Search::Intent.check_requested_query(search_string)
    # database search
    #result = where(:inactive => [false, nil]).where('name = ?', search_string).all
    result = where(:inactive => [false, nil]).where('name LIKE (?)', "%#{search_string}%").all
    # elastic search
    if result.length == 0
      keywords = search_string.split(' ')
      current_query = "\"#{search_string}\""
      result = self.elasticsearch(current_query)
      puts 'current_query Ir:' + current_query
      if result.length == 0
        current_query = ''
        keywords.each_with_index { |keyword, index|
          current_query += ' ' if index > 0
          current_query += "+#{keyword}"
        }
        puts 'current_query ir' + current_query
        result = self.elasticsearch(current_query)
        if result.length == 0
          current_query = ''
          keywords.each_with_index { |keyword, index|
            current_query += ' ' if index > 0
            current_query += "+#{keyword}*"
          }
          puts 'current_query ir:' + current_query
          result = self.elasticsearch(current_query)
        end
      end
    end
    result.nil? ? [] : result
  end

  def self.elasticsearch(search_query)
    begin
      self.search(:load => true, :per_page => 6) do
        query do
          boolean do
            must { string search_query }
            must { term :inactive, false }
          end
        end
        sort { by :name, 'asc' }
      end
    rescue => e
      Rails.logger.info "\n=============SEARCH ERROR TRACE======================\n"
      Rails.logger.info "\n Query::#{search_query} \n"
      Rails.logger.info "\n Message::#{e.message} \n"
      Rails.logger.info "\n Error Class::#{e.class} \n"
      Rails.logger.info "\n=============END OF SEARCH ERROR TRACE================\n"
      # $notify_team.each do |developer|
      #   SearchMailer.search_error_notification(developer, e, search_query).deliver
      # end
      return []
    end
  end

  def self.fetch_advertisers_for_primary_cat(product_category, max_advertisers)
    advertiser_tiers = product_category.ir_preferred_advertisers + product_category.ir_non_preferred_advertisers
    advertiser_tiers.flatten.uniq.first(max_advertisers)
  end

  def id_with_class_name
    "#{self.class.name}.#{id}"
  end

  def searchable_name
    name.gsub(".com", "")
  end
  
  def image_url
    image.url(:iphone)
  end
end
