class LoyaltyProgram < ActiveRecord::Base
  
  has_many :stores, :as => :storable, :dependent => :destroy
  
  has_many :loyalty_programs_users, dependent: :destroy
  has_many :users, through: :loyalty_programs_users
  has_many :loyalty_program_coupons, dependent: :destroy
  has_many :loyalty_program_offers, dependent: :destroy
  belongs_to :vendor
  
  
  accepts_nested_attributes_for :loyalty_programs_users
  acts_as_commentable
  
  has_attached_file :logo_image, 
    MuddleMe::Configuration.paperclip_options[:loyalty_programs][:logo_image]
  
  validates_attachment_content_type :logo_image, :content_type=>BROWSER_SUPPORTED_IMAGE_MIME_TYPES
  
  
  has_attached_file :icon_image, 
    MuddleMe::Configuration.paperclip_options[:loyalty_programs][:icon_image]
  
  validates_attachment_content_type :icon_image, :content_type=>BROWSER_SUPPORTED_IMAGE_MIME_TYPES
  
  
  # include Tire::Model::Search
  # include Tire::Model::Callbacks

  def logo_image_url
    logo_image.url
  end
  
   def icon_image_url
    icon_image.url
  end
  
  def personal_offers_count
    if !personal_offers.nil?
      personal_offers.count
    else
      0
    end
  end

  
  def coupons_count
    self.loyalty_program_coupons.count + self.cj_coupons.count + self.avant_coupons.count + self.pj_coupons.count + self.ir_coupons.count + self.linkshare_coupons.count  
  end
  
  def loyalty_program_api_params
    {icon_image_url: icon_image_url,
     logo_image_url: logo_image_url,
     personal_offers_count: personal_offers_count,
     coupons_count: coupons_count
    }
  end
  
  def cj_coupons
     word="%"+self.name+"%"
    CjCoupon.where("advertiser_name like ? AND (HEADER IS NOT NULL OR HEADER <> ?)",word, '') 
  end
  
  def avant_coupons
     word="%"+self.name+"%"
    AvantCoupon.where("advertiser_name like ? AND (HEADER IS NOT NULL OR HEADER <> ?)",word, '') 
  end
  
  def pj_coupons
     word="%"+self.name+"%"
   PjCoupon.where("advertiser_name like ? AND (HEADER IS NOT NULL OR HEADER <> ?)",word, '') 
  end
  
  def ir_coupons
    word="%"+self.name+"%"
    IrCoupon.where("advertiser_name like ? AND (HEADER IS NOT NULL OR HEADER <> ?)",word, '') 
  end
  
  def linkshare_coupons
   word="%"+self.name+"%"
   LinkshareCoupon.where("advertiser_name like ? AND (HEADER IS NOT NULL OR HEADER <> ?)",word, '') 
  end
  
  def cj_offers
     word="%"+self.name+"%"
    CjOffer.where("advertiser_name like ?",word).as_json(except: :params)
  end
  
  def avant_offers
    word="%"+self.name+"%"
    AvantOffer.where("advertiser_name like ?",word)   
  end
  
  def personal_offers
    if !vendor.nil?
        vendor.offers.where(service_type: "personal") 
    end
       
  end
  
#  def coupons
#    {loyalty_program_coupons: self.loyalty_program_coupons,
#      cj_coupons: self.cj_coupons,
#      avant_coupons: self.avant_coupons,
#      pj_coupons: self.pj_coupons,
#      ir_coupons: self.ir_coupons,
#      linkshare_coupons: self.linkshare_coupons     
#    }
#  end
  def affiliate_coupons
      self.cj_coupons+self.avant_coupons+self.pj_coupons+self.ir_coupons+self.linkshare_coupons     
  end
  def offers
    {loyalty_program_offers: self.loyalty_program_offers.as_json(methods: :offer_video_url),
     # cj_offers: self.cj_offers,
     # avant_offers: self.avant_offers    
    }
  end
 
   def affiliates_offers
      offers=self.cj_offers+self.avant_offers
  end
end

#l = LoyaltyProgram.new(name: 'ACE Hardware', logo_image: File.open('/home/arkhitech/Desktop/acehardware.png'))