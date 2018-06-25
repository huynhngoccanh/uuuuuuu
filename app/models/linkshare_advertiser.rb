class LinkshareAdvertiser < ActiveRecord::Base
  MAX_PARALLEL_QUERIES = 20

  serialize :params
  belongs_to :merchant
  has_many :linkshare_advertiser_category_mappings
  has_many :product_categories, :through => :linkshare_advertiser_category_mappings
  has_many :coupons, :class_name => 'LinkshareCoupon', :foreign_key => 'advertiser_id',
    :primary_key => 'advertiser_id', :dependent => :restrict_with_error
  has_many :unexpired_coupons, -> {where('expires_at IS NULL or expires_at >= ?', Date.today)}, :class_name => 'LinkshareCoupon', :foreign_key => 'advertiser_id', :primary_key => 'advertiser_id', :dependent => :restrict_with_error
  has_many :favorite_advertisers, :dependent => :destroy
  has_many :hp_stores, :dependent => :destroy
  has_one :hp_advertiser_image,  :as => :imageable, :dependent=>:destroy
  has_many :stores, :as => :storable, :dependent=>:destroy
  has_many :mcb_updates, :as => :alertable, :dependent => :destroy
  has_many :user_coupons, :as => :advertisable
  has_many :favorite_merchants, :as => :advertisable
  
  has_attached_file :image,
    MuddleMe::Configuration.paperclip_options[:linkshare_advertisers][:image]
  validates_attachment_content_type :image, :content_type=>BROWSER_SUPPORTED_IMAGE_MIME_TYPES

  validates :advertiser_id, :presence => true
  validates :base_offer_id, :presence => true # used to always have trackable link
  validates :name, :presence => true

  # include Tire::Model::Search
  # include Tire::Model::Callbacks
  
  
  acts_as_commentable

  # def logo
    
  # end

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
      puts 'current_query linkshare:' + current_query
      if result.length == 0
        current_query = ''
        keywords.each_with_index { |keyword, index|
          current_query += ' ' if index > 0
          current_query += "+#{keyword}"
        }
        puts 'current_query linkshare:' + current_query
        result = self.elasticsearch(current_query)
        if result.length == 0
          current_query = ''
          keywords.each_with_index { |keyword, index|
            current_query += ' ' if index > 0
            current_query += "+#{keyword}*"
          }
          puts 'current_query linkshare:' + current_query
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

  def set_attributes_from_response_row(row)
    self.name = row['name']
    self.advertiser_id = row['mid']
    self.params = row
    return self if row['offer'].blank? || row['offer']['offerId'].blank? || row['offer']['commissionTerms'].blank?
    self.base_offer_id = row['offer']['offerId']
    self.inactive = false

    # fetch max comission value from main offer
    comission_terms = row['offer']['commissionTerms'].strip
    matches = /.+ (\d*[,.]?[\d+]?%?)$/.match(comission_terms)
    if matches && matches.length > 1
      (matches[1].index '%') ? self.max_commission_percent = (matches[1].sub '%', '').to_f : self.max_commission_dollars = matches[1].to_f
    end

    # fetch logo urls
    self.logo_url = "http://merchant.linksynergy.com/fs/logo/lg_#{self.advertiser_id}"
    logo_url_https = "https://merchant.linksynergy.com/fs/logo/lg_#{self.advertiser_id}"
    extension_code = lambda { |extension|
      url = URI.parse(self.logo_url + extension)
      req = Net::HTTP.new(url.host, url.port)
      res = req.request_head(url.path)
      res.code
    }
    if extension_code.call('.jpg') == '404'
      if extension_code.call('.gif') == '404'
        self.logo_url = extension_code.call('.png') == '404' ? nil : logo_url_https + '.png'
      else
        self.logo_url = logo_url_https + '.gif'
      end
    else
      self.logo_url =  logo_url_https + '.jpg'
    end
    self
  end

  def self.fetch_advertisers_for_primary_cat(product_category, max_advertisers)
    advertiser_tiers = product_category.linkshare_preferred_advertisers + product_category.linkshare_non_preferred_advertisers
    advertiser_tiers.flatten.uniq.first(max_advertisers)
  end

  def self.reload_all_advertisers
    puts 'LinkshareAdvertiser.reload_all_advertisers'

    advertisers_to_delete = self.where(:inactive => [false, nil]).to_a
    approved_advertisers = Linkshare.advertisers_by_status(Linkshare::ADVERTISER_STATUSES[:approved])

    # save/update advertisers
    LinkshareAdvertiser.transaction do
      approved_advertisers.each do |row|
        puts row['name']
        advertiser = advertisers_to_delete.find { |a| a.advertiser_id.to_s == row['mid'] }
        advertisers_to_delete.delete(advertiser) if advertiser
        advertiser ||= self.where(advertiser_id: row['mid']).first_or_initialize
        advertiser.set_attributes_from_response_row(row).save
         @merchant = Merchant.where(name: row["name"]).first_or_initialize
         @merchant.image = advertiser.image
          if @merchant.new_record?
            @merchant.save
          end
          @merchant.update_attributes(active_status: true)
          advertiser.update_attributes(merchant_id: @merchant.id)
          @merchant.update_merchant_slug
      end
    end

    LinkshareAdvertiser.transaction { advertisers_to_delete.each { |a| a.update_attribute :inactive, true } }

    # get website urls
    advertisers = self.where(:inactive => [false, nil]).to_a
    hydra = Typhoeus::Hydra.new(:max_concurrency => MAX_PARALLEL_QUERIES)
    advertiser_all_websites = {}
    0.upto(advertisers.length - 1) do |i|
      request = Typhoeus::Request.new(advertisers[i].base_tracking_url, :method => :head, :followlocation => true, :maxredirs => 10)
      request.on_complete do |response|
        advertiser_websites = []
        uri = URI.parse(response.effective_url)
        if uri.host.index 'affiliatetechnology'
          advertiser_websites << uri.scheme + '://www.' + uri.host.sub('.affiliatetechnology', '').downcase
          second_uri = URI.extract(URI.unescape(uri.query))
          unless second_uri.length == 0
            uri = URI.parse(second_uri[0])
            second_advertiser_website = uri.scheme + '://' + uri.host.downcase
            advertiser_websites << second_advertiser_website
          end
        else
          advertiser_websites << uri.scheme + '://' + uri.host.downcase
        end
        advertiser_all_websites[i] = advertiser_websites.uniq
      end
      hydra.queue request
    end
    hydra.run

    # Update website attribute for all advertisers
    LinkshareAdvertiser.transaction do
      advertiser_all_websites.each do |key, array|
        if array.blank? || array[0].index('localhost').present?
          advertisers[key].update_attributes(:inactive => true)
        else
          advertisers[key].update_attributes(:website => array.join(' '))
        end
      end
    end
    $notify_team.each do |developer|
      ContactMailer.new_advertisers_data_notification("Linkshare", developer).deliver
    end
  end

  def base_tracking_url
    "http://click.linksynergy.com/fs-bin/click?id=#{$linkshare_publisher_uid}&offerid=#{base_offer_id}&type=4"
  end

  def advertiser_url
    unless website.blank?
      websites = website.split(' ')
      websites.last
    end
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
