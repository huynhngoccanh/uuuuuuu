require 'uri'
require 'cgi'

class Offer < ActiveRecord::Base
  belongs_to :vendor
  has_many :campaigns, :dependent=>:restrict_with_error
  has_many :offer_images, :dependent=>:destroy
  has_many :bids, :dependent=>:destroy
  
  attr_accessor :dont_require_barcode_image, :dont_require_offer_images, :dont_require_name, :dont_require_offer_description, :dont_require_expiration_time
  
  has_attached_file :offer_video,
    MuddleMe::Configuration.paperclip_options[:offers][:offer_video]
  validates_attachment_content_type :offer_video, :content_type=>BROWSER_SUPPORTED_VIDEO_MIME_TYPES
  attr_accessible :offer_video_file_name, :offer_video_content_type, :offer_video_file_size
  
  has_attached_file :barcode_image, 
    MuddleMe::Configuration.paperclip_options[:offers][:barcode_image]
  validates_attachment_content_type :barcode_image, :content_type=>BROWSER_SUPPORTED_IMAGE_MIME_TYPES
  
  
  validates :offer_description, presence: true, :unless=>Proc.new{dont_require_offer_description}
  validates :expiration_time, presence: true, :unless=>Proc.new{dont_require_expiration_time}
  validates :offer_images, presence: true, :unless=>Proc.new{dont_require_offer_images}  
  validates :barcode_image, presence: true, :unless=>Proc.new{dont_require_barcode_image}
  validates :vendor_id, :presence=>true
  validates :name, :presence=>true, :length => { :maximum => 200 }, :unless=>Proc.new{dont_require_name}
  validates :coupon_code, :length => { :maximum => 200 }
  validates :offer_url, :length => { :maximum => 200 }, :format => /[-a-zA-Z0-9@:%_\+.~#?&\/\/=]{2,256}\.[a-z]{2,4}\b(\/[-a-zA-Z0-9@:%_\+.~#?&\/\/=]*)?/i , 
            :allow_blank=>true
          
  #parsable by URI parser        
  validate do
    unless offer_url.blank?
      begin
        URI.parse(offer_url)
      rescue
        errors.add(:offer_url, 'is invalid') #FIXME get this from i18n texts
      end
    end
  end

  attr_protected :vendor_id

  default_scope -> {where(:is_deleted=>false)}

  TYPE_SERVICE = 'service'
  TYPE_PRODUCT = 'product'
  TYPE_PERSONAL = 'personal'
  
  def editable?
    bids.index{|b| b.is_winning}.nil?
  end
  
  def trackable_offer_url auction_id
    return offer_url if offer_url.blank?
    uri = URI.parse(offer_url)
    uri.query = [uri.query.blank? ? nil : uri.query, "#{VendorTrackingEvent::AUCTION_ID_PARAM_NAME}=#{auction_id}"].
      compact.join('&')
    uri.to_s
  end

  def to_api_json
    attrs = [:name, :coupon_code, :offer_url, :offer_description, :expiration_time]
    result = attrs.inject({}) {|result, attr| result[attr] = send(attr.to_s); result}
    result[:images] = offer_images.map(&:to_api_json)
    result
  end

  def product_offer
    #read_attribute(:product_offer)
    #offer.read_attribute(:product_offer)
    TYPE_PRODUCT == :service_type
  end
  
  def product_offer?
    TYPE_PRODUCT == :service_type
  end
  
  
  def barcode_image_url
    barcode_image.url
  end

  
  def offer_video_url
    offer_video.url
  end
  
  def offer_images_url
    offer_images.as_json(:only => [:image_url], :methods =>[:image_url])
  end
  

  
#   def personal_offer_url
#    {
#      offer_video_url: offer_video_url,
#      #offer_image: offer_images.as_json(methods: :image_url),
#      offer_image: offer_images.as_json(:only => [:image_url], :methods =>[:image_url]),
#      barcode_image_url: barcode_image_url
#    }
#  end


end
