class AvantAdvertiser < ActiveRecord::Base
  include HTTParty
  serialize :params
  belongs_to :merchant
  has_many :avant_advertiser_category_mappings
  has_many :product_categories, :through=>:avant_advertiser_category_mappings
  has_many :avant_offers, :foreign_key=>'advertiser_id', :primary_key=>'advertiser_id', :dependent=>:destroy
  has_many :coupons, :class_name=>'AvantCoupon', :foreign_key=>'advertiser_id',
       :primary_key=>'advertiser_id', :dependent=>:restrict_with_error
  has_many :unexpired_coupons, -> {where('expires_at IS NULL or expires_at >= ?', Date.today)}, :class_name=>'AvantCoupon', :foreign_key=>'advertiser_id', :primary_key=>'advertiser_id', :dependent=>:restrict_with_error
  has_many :favorite_advertisers, :dependent => :destroy
  has_many :hp_stores, :dependent => :destroy
  has_one :hp_advertiser_image,  :as => :imageable, :dependent=>:destroy
  has_many :stores, :as => :storable, :dependent=>:destroy
  has_many :user_coupons, :as => :advertisable
  has_many :favorite_merchants, :as => :advertisable
  
  has_attached_file :image,
    MuddleMe::Configuration.paperclip_options[:avant_advertisers][:image]
  validates_attachment_content_type :image, :content_type=>BROWSER_SUPPORTED_IMAGE_MIME_TYPES
 

 
  has_attached_file :logo,
    MuddleMe::Configuration.paperclip_options[:avant_advertisers][:logo]
  validates_attachment_content_type :logo, :content_type=>BROWSER_SUPPORTED_IMAGE_MIME_TYPES

  validates :advertiser_id, :presence => true
  validates :name, :presence => true

  # include Tire::Model::Search
  # include Tire::Model::Callbacks

  acts_as_commentable
  
  def to_indexed_json
    {:id => id, :name => name, :inactive => (inactive == nil || inactive)}.to_json
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
      puts 'current_query avant:' + current_query
      if result.length == 0
        current_query = ''
        keywords.each_with_index { |keyword, index|
          current_query += ' ' if index > 0
          current_query += "+#{keyword}"
        }
        puts 'current_query avant:' + current_query
        result = self.elasticsearch(current_query)
        if result.length == 0
          current_query = ''
          keywords.each_with_index { |keyword, index|
            current_query += ' ' if index > 0
            current_query += "+#{keyword}*"
          }
          puts 'current_query avant:' + current_query
          result = self.elasticsearch(current_query)
        end
      end
    end
    result.nil? ? [] : result
  end

  def self.elasticsearch(search_query)
    begin
      self.search(:load => true, :per_page => 4) do
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

  def set_attributes_from_response_row row
    self.name          = row['Merchant_Name']
    self.advertiser_id = row['Merchant_Id']
    self.advertiser_url = row['Merchant_URL']
    self.commission_percent = row['Commission_Rate'].gsub('%','').to_f if row['Commission_Rate'].match('\%')
    self.commission_dollars = row['Commission_Rate'].gsub('$','').to_f if row['Commission_Rate'].match('\$')
    self.params        = row
    self.inactive      = false

    client = HTTPClient.new
    image_req = client.get(row['Merchant_Logo'].gsub('https', 'http'))
    return self if image_req.http_header.status_code != 200
    self.logo = StringIO.new(image_req.body)
    self.logo.instance_write(:content_type, image_req.content_type)
    self.logo.instance_write(:file_name, row['Merchant_Logo'].gsub(/[^\/]*\//, ''))
    self
  end

  def self.fetch_advertisers_for_primary_cat(product_category, max_advertisers)
    advertiser_tiers = product_category.avant_preferred_advertisers + product_category.avant_non_preferred_advertisers
    advertiser_tiers.flatten.uniq.first(max_advertisers)
  end

  def self.reload_all_advertisers
    puts 'AvantAdvertiser.reload_all_advertisers'

    advertisers_to_delete = self.where(:inactive=>[false,nil]).to_a
    inserted_count = 0
    response = Avant.joined_advertisers
    AvantAdvertiser.transaction do
      response.to_a.each do |row|
        puts "AVANT::" + row['Merchant_Name']
        advertiser = advertisers_to_delete.find { |a| a.advertiser_id == row['Merchant_Id'] }
        advertisers_to_delete.delete(advertiser) if advertiser
        advertiser ||= self.where(advertiser_id: row['Merchant_Id']).first_or_initialize
        saved = advertiser.set_attributes_from_response_row(row).save
        @merchant = Merchant.where(name: row["Merchant_Name"]).first_or_initialize
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

    AvantAdvertiser.transaction { advertisers_to_delete.each{|a| a.update_attribute :inactive, true} }
    inserted_count
    $notify_team.each do |developer|
      ContactMailer.new_advertisers_data_notification("Avant", developer).deliver
    end
  end

  def base_tracking_url
    self.params['Default_Tracking_URL'] || "http://www.avantlink.com/click.php?tt=cl&mi=#{self.advertiser_id}&pw=#{$avant_website_id}"
  end

  def max_commission_percent
    commission_percent
  end

  def max_commission_dollars
    commission_dollars
  end

  def mobile_enabled
    true
  end

  def id_with_class_name
    "#{self.class.name}.#{id}"
  end

  def advertiser_url
    params['program_url']
  end

  def id_with_class_name
    "#{self.class.name}.#{id}"
  end


  def image_url
    image.url(:iphone)
  end
end
