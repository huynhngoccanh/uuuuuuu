class CjAdvertiser < ActiveRecord::Base
  MAX_PARALLEL_QUERIES = 100

  serialize :params
  belongs_to :merchant
  has_many :cj_advertiser_category_mappings
  has_many :product_categories, :through=>:cj_advertiser_category_mappings
  has_many :cj_offers, :foreign_key=>'advertiser_id', :primary_key=>'advertiser_id', :dependent=>:restrict_with_error
  has_many :coupons, :class_name=>'CjCoupon', :foreign_key=>'advertiser_id',
      :primary_key=>'advertiser_id', :dependent=>:restrict_with_error
  has_many :unexpired_coupons, -> {where('expires_at IS NULL or expires_at >= ?', Date.today)}, :class_name=>'CjCoupon', :foreign_key=>'advertiser_id', :primary_key=>'advertiser_id', :dependent=>:restrict_with_error
  has_many :favorite_advertisers, :dependent => :destroy
  has_many :hp_stores, :dependent => :destroy
  has_one  :hp_advertiser_image,  :as => :imageable, :dependent=>:destroy
  has_many :stores, :as => :storable, :dependent=>:destroy
  has_many :mcb_updates, :as => :alertable, :dependent => :destroy
  has_many :user_coupons, :as => :advertisable
  has_many :favorite_merchants, :as => :advertisable

  has_attached_file :image,
    MuddleMe::Configuration.paperclip_options[:cj_advertisers][:image]
  validates_attachment_content_type :image, :content_type=>BROWSER_SUPPORTED_IMAGE_MIME_TYPES

  CJ_BASE_URL = "https://members.cj.com/member/"
  CJ_MEMBER_CREDS = {:uname=>'kevin@muddleme.com', :pw=>'JUx9QEx'}


#  Advertiser has one loyalty program
#  Advertiser has many vendors
#  
#  Advertiser is a polymorphic association can be cj, avant, ....advertiser 
  
  has_attached_file :logo,
    MuddleMe::Configuration.paperclip_options[:cj_advertisers][:logo]
  validates_attachment_content_type :logo, :content_type=>BROWSER_SUPPORTED_IMAGE_MIME_TYPES

  validates :advertiser_id, :presence => true
  validates :name, :presence => true

  # include Tire::Model::Search
  # include Tire::Model::Callbacks
  
  acts_as_commentable
  
  def logo_url
    logo.url
  end

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
      puts 'current_query cj:' + current_query
      if result.length == 0
        current_query = ''
        keywords.each_with_index { |keyword, index|
          current_query += ' ' if index > 0
          current_query += "+#{keyword}"
        }
        puts 'current_query cj:' + current_query
        result = self.elasticsearch(current_query)
        if result.length == 0
          current_query = ''
          keywords.each_with_index { |keyword, index|
            current_query += ' ' if index > 0
            current_query += "+#{keyword}*"
          }
          puts 'current_query cj:' + current_query
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
    advertiser_tiers = product_category.cj_preferred_advertisers + product_category.cj_non_preferred_advertisers
    advertiser_tiers.flatten.uniq.first(max_advertisers)
  end

  def set_attributes_from_response_row row
    self.name           = row['advertiser_name']
    self.advertiser_id  = row['advertiser_id']
    self.sample_link_id = row['sample_link_id']
    self.inactive       = false
    self.params         = row
    return self if !row['actions'] && !row['actions']['action']

    commissions = row['actions']['action']
    commissions = [commissions] if !row['actions']['action'].is_a? Array
    default_commissions = commissions.map{|c| c['commission']['default']}
    all_commission_dollars = []
    all_commission_percents = []

    commissions.each do |c|
      if c['commission']['itemlist']
        items = c['commission']['itemlist']
        items = [items] if !items.is_a? Array
        items.each do |i|
          if i['__content__'].match '%'
            all_commission_percents << i['__content__'].to_f
          else
            all_commission_dollars << i['__content__'].gsub('USD','').strip.to_f
          end
        end
      end
      if c['commission']['default'].is_a? String
        all_commission_percents << c['commission']['default'].to_f
      else
        all_commission_dollars << c['commission']['default']['__content__'].gsub('USD','').strip.to_f
      end
    end
    all_commission_percents.delete_if{|c| c.to_i == 100}

    commission_percents = default_commissions.reject{|c| !c.is_a? String}.map{|c| c.to_f}
    unless commission_percents.blank?
      self.commission_percent = commission_percents.inject{ |sum, el| sum + el } / commission_percents.size.to_f
    end
    self.max_commission_percent = all_commission_percents.max unless all_commission_percents.blank?

    commission_dollars_arr = default_commissions.reject{|c| c.is_a? String}.map{|c| c['__content__'].gsub('USD','').strip.to_f}
    unless commission_dollars_arr.blank?
      self.commission_dollars = commission_dollars_arr.inject{ |sum, el| sum + el } / commission_dollars_arr.size.to_f
    end

    self.max_commission_dollars = all_commission_dollars.max unless all_commission_dollars.blank?
    
    self
  end

  def self.reload_all_advertisers
    puts 'CjAdvertiser.reload_all_advertisers'
    advertisers_to_delete = self.where(:inactive=>[false,nil]).to_a
    page = 0
    inserted_count = 0

    begin
      page += 1
      response = CJ.joined_advertisers page
      break if response.nil? || response['advertisers'].blank? || response['advertisers']['advertiser'].blank?
      advertisers = response['advertisers']['advertiser']
      advertisers = [advertisers] unless advertisers.is_a? Array

      self.collect_sample_link_ids(advertisers)
    
      # collect advertisers
      self.transaction do
        advertisers.each do |row|
          puts row['advertiser_name']
          advertiser = advertisers_to_delete.find { |a| a.advertiser_id == row['advertiser_id'] }
          advertisers_to_delete.delete(advertiser) if advertiser
          advertiser ||= self.where(advertiser_id: row['advertiser_id']).first_or_initialize
          saved = advertiser.set_attributes_from_response_row(row).save

            @merchant = Merchant.where(name: row["advertiser_name"]).first_or_initialize
            @merchant.image = advertiser.logo
            if @merchant.new_record?
              @merchant.save
            end
          if !advertiser.sample_link_id.blank?              
            @merchant.update_attributes(active_status: true)
            advertiser.update_attributes(merchant_id: @merchant.id)
          else
            @merchant.update_attributes(active_status:false)
          end 
          
            @merchant.update_merchant_slug
          inserted_count += 1 if saved
        end
      end
    end until (page-1)* CJ::PER_PAGE + response['advertisers']['records_returned'].to_i >= response['advertisers']['total_matched'].to_i

    self.transaction { advertisers_to_delete.each{|a| a.update_attribute :inactive, true} }

    # we should make sure all links collected, try collect links several times and increase sleep after each attempt
    i = 1
    while i < 1 do
      advertisers = self.where(:sample_link_id => nil).where(:inactive => [false,nil]).to_a
      break unless advertisers.length
      self.collect_sample_link_ids advertisers
      self.transaction { advertisers.each{|a| a.save } }
      sleep i * 30
      i += 1
    end
    # Finally update all without link to inactive
    self.where('sample_link_id is null').update_all({:inactive => true})
    inserted_count
    $notify_team.each do |developer|
      ContactMailer.new_advertisers_data_notification("Commission Junction", developer).deliver
    end

  end

  def self.collect_sample_link_ids(advertisers)
    # collect sample link_id for each advertiser
    sample_link_hydra = Typhoeus::Hydra.new(:max_concurrency => MAX_PARALLEL_QUERIES)
    advertisers.each do |row|
      sample_link_request = CJ.request_for_trackable_url(row['advertiser_id'])
      sample_link_request.on_complete do |link_response|
        if link_response.success?
          body = Hash.from_xml(link_response.body)
          cj_result = CJ.check_result body
          if (cj_result && cj_result['links'] && cj_result['links']['link'] && cj_result['links']['link']['link_id'] && cj_result['links']['link']['advertiser_id'])
            row['sample_link_id'] = cj_result['links']['link']['link_id'] 
          end
        end
      end
      sample_link_hydra.queue(sample_link_request)
    end
    sample_link_hydra.run
    sleep 5 # sleep some time between pages to make sure query limit not reached
  end

  def self.fetch_advertisers_logos show_progressbar=false
    client = HTTPClient.new
    resp = client.post(CJ_BASE_URL + 'foundation/memberlogin.do', CJ_MEMBER_CREDS)
    bar = nil
    if show_progressbar
      bar = RakeProgressbar.new(self.where('inactive IS NULL OR inactive=0').count )
    end
    self.all.each do |advertiser|
      next if advertiser.inactive
      next unless advertiser.logo_file_name.blank?
      path = "accounts/publisher/getadvertiserdetail.do?advertiserId=#{advertiser.advertiser_id}"
      body = client.get(CJ_BASE_URL + path).body
      logo_path = body.match(/publisher\/logo\/([^"]+)/)
      bar.inc if bar
      next if logo_path.nil?
      image_req = client.get(CJ_BASE_URL + logo_path[0])
      advertiser.logo = StringIO.new(image_req.body)
      advertiser.logo.instance_write(:content_type, image_req.content_type)
      advertiser.logo.instance_write(:file_name, logo_path[1])
      advertiser.save
    end
  end

  def base_tracking_url
    CjAdvertiser.tracking_url(sample_link_id)
  end

  def self.tracking_url(link_id)
    "http://#{CJ.tracking_domain}/click-#{$cj_website_id}-#{link_id}"
  end

  def advertiser_url
    params['program_url']
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
